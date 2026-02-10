; Override template strings inside Angular components
(pair
    key: (property_identifier) @_key
    (#eq? @_key "template")
    value: (template_string) @angular.template)
