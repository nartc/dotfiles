#!/usr/bin/env node

import { execFileSync } from 'node:child_process';

const DEFAULT_ORG = 'Polygraph-Demo-Test';
const OP_VAULT = 'Chau Personal';
const OP_ITEM = 'Polygraph Demo PAT';
const API_VERSION = '2022-11-28';
const TEMPLATE_REPOS_BY_ORG = new Map([
  ['polygraph-demo-test', ['poly-frontend', 'poly-backend', 'poly-design']],
]);

const args = parseArgs(process.argv.slice(2));

if (args.help) {
  printHelp();
  process.exit(0);
}

const org = args.org ?? DEFAULT_ORG;
const patEnv = getPatEnvForOrg(org);
const keepRepos = getKeepRepos({ org, keepArg: args.keep });
const deleteMode = args.delete === true;
const tokenKind = deleteMode ? 'write' : 'read';
const token = getToken({ patEnv, tokenKind });

if (keepRepos.size === 0) {
  fail('Refusing to run without a template keep list. Add this org to TEMPLATE_REPOS_BY_ORG or pass --keep repo-a,repo-b.');
}

const repos = await listOrgRepos(org, token);
const matchedRepos = repos.filter((repo) => !keepRepos.has(repo.name));

printPlan({ org, patEnv, tokenKind, keepRepos, repos, matchedRepos, deleteMode });

if (matchedRepos.length === 0) {
  process.exit(0);
}

if (!deleteMode) {
  console.log('\nDry run only. Add --delete --yes after reviewing this list.');
  process.exit(0);
}

if (args.yes !== true) {
  console.log('\nDry run only. --delete was provided, but --yes is required.');
  process.exit(0);
}

console.log('\nDeleting repositories...');
for (const repo of matchedRepos) {
  await deleteRepo(org, repo.name, token);
  console.log(`deleted ${repo.full_name}`);
}

console.log(`\nDone. Deleted ${matchedRepos.length} repos from ${org}.`);

function parseArgs(rawArgs) {
  const parsed = {};

  for (let i = 0; i < rawArgs.length; i++) {
    const arg = rawArgs[i];

    if (arg === '--help' || arg === '-h') {
      parsed.help = true;
      continue;
    }

    if (arg === '--delete' || arg === '--yes') {
      parsed[arg.slice(2)] = true;
      continue;
    }

    if (arg === '--keep') {
      const value = rawArgs[i + 1];
      if (!value || value.startsWith('--')) fail('Missing value for --keep');
      parsed.keep = value;
      i++;
      continue;
    }

    if (arg.startsWith('--')) {
      fail(`Unknown flag: ${arg}`);
    }

    if (parsed.org) {
      fail(`Unexpected extra argument: ${arg}`);
    }

    parsed.org = arg;
  }

  return parsed;
}

function parseKeepRepos(value) {
  if (!value) return new Set();

  return new Set(
    value
      .split(',')
      .map((repo) => repo.trim())
      .filter(Boolean)
  );
}

function getKeepRepos({ org, keepArg }) {
  const explicitKeepRepos = parseKeepRepos(keepArg);
  if (explicitKeepRepos.size > 0) return explicitKeepRepos;

  return new Set(TEMPLATE_REPOS_BY_ORG.get(org.toLowerCase()) ?? []);
}

function getPatEnvForOrg(org) {
  if (/test/i.test(org)) return 'Test';
  return 'Prod';
}

function getToken({ patEnv, tokenKind }) {
  if (process.env.GITHUB_TOKEN) {
    return process.env.GITHUB_TOKEN;
  }

  const uri = `op://${OP_VAULT}/${OP_ITEM}/${patEnv}/${tokenKind}`;

  try {
    return execFileSync('op', ['read', uri], {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'pipe'],
    }).trim();
  } catch (error) {
    const stderr = error.stderr?.toString()?.trim();
    fail(`Failed to read token from 1Password URI ${uri}.${stderr ? ` ${stderr}` : ''}`);
  }
}

async function listOrgRepos(owner, token) {
  const repos = [];
  let page = 1;

  while (true) {
    const pageRepos = await github(`/orgs/${encodeURIComponent(owner)}/repos?per_page=100&page=${page}&type=all`, { token });

    if (!Array.isArray(pageRepos)) {
      fail('Unexpected GitHub API response while listing repos.');
    }

    repos.push(...pageRepos);

    if (pageRepos.length < 100) return repos;
    page++;
  }
}

async function deleteRepo(owner, repoName, token) {
  await github(`/repos/${encodeURIComponent(owner)}/${encodeURIComponent(repoName)}`, {
    method: 'DELETE',
    token,
  });
}

async function github(path, { token, method = 'GET' } = {}) {
  const response = await fetch(`https://api.github.com${path}`, {
    method,
    headers: {
      Accept: 'application/vnd.github+json',
      Authorization: `Bearer ${token}`,
      'X-GitHub-Api-Version': API_VERSION,
    },
  });

  if (response.status === 204) return null;

  const text = await response.text();
  const body = text ? tryParseJson(text) : null;

  if (!response.ok) {
    const message = body?.message ?? text ?? response.statusText;
    fail(`GitHub API ${response.status} ${response.statusText}: ${message}`);
  }

  return body;
}

function tryParseJson(text) {
  try {
    return JSON.parse(text);
  } catch {
    return text;
  }
}

function printPlan({ org, patEnv, tokenKind, keepRepos, repos, matchedRepos, deleteMode }) {
  const visibleRepoNames = new Set(repos.map((repo) => repo.name));
  const hiddenOrMissingKeepRepos = [...keepRepos].filter((repo) => !visibleRepoNames.has(repo)).sort();

  console.log(`Org: ${org}`);
  console.log(`PAT env: ${patEnv}`);
  console.log(`Token: ${tokenKind}`);
  console.log(`Repos scanned: ${repos.length}`);
  console.log(`Keep repos: ${keepRepos.size}`);
  for (const repo of [...keepRepos].sort()) {
    console.log(`  keep ${repo}`);
  }
  if (hiddenOrMissingKeepRepos.length > 0) {
    console.log('Keep repos not visible to this token:');
    for (const repo of hiddenOrMissingKeepRepos) {
      console.log(`  invisible ${repo}`);
    }
  }
  console.log(`Repos to delete: ${matchedRepos.length}`);
  for (const repo of matchedRepos) {
    console.log(`  delete ${repo.full_name}`);
  }
  console.log(`Mode: ${deleteMode ? 'DELETE requested' : 'DRY RUN'}`);
}

function printHelp() {
  console.log(`
Usage:
  node delete-non-template-repos.mjs [org] --keep repo-a,repo-b
  node delete-non-template-repos.mjs [org] --keep repo-a,repo-b --delete --yes

Defaults:
  org: ${DEFAULT_ORG}
  token: read for dry-run, write for delete
  pat env: org containing "test" => Test, otherwise Prod

Flags:
  --keep <repo-a,repo-b>  exact repo names to preserve
  --delete               request destructive mode
  --yes                  required with --delete
  --help                 show help

Examples:
  node delete-non-template-repos.mjs --keep react-template,node-template
  node delete-non-template-repos.mjs Polygraph-Demo-Test --keep react-template,node-template --delete --yes
`);
}

function fail(message) {
  console.error(`Error: ${message}`);
  process.exit(1);
}
