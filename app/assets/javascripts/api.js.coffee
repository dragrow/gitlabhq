@Api =
  groups_path: "/api/:version/groups.json"
  group_path: "/api/:version/groups/:id.json"
  projects_path: "/api/:version/projects.json"
  ldap_groups_path: "/api/:version/ldap/:provider/groups.json"
  namespaces_path: "/api/:version/namespaces.json"

  group: (group_id, callback) ->
    url = Api.buildUrl(Api.group_path)
    url = url.replace(':id', group_id)

    $.ajax(
      url: url
      data:
        private_token: gon.api_token
      dataType: "json"
    ).done (group) ->
      callback(group)

  # Return groups list. Filtered by query
  # Only active groups retrieved
  groups: (query, skip_ldap, callback) ->
    url = Api.buildUrl(Api.groups_path)

    $.ajax(
      url: url
      data:
        private_token: gon.api_token
        search: query
        per_page: 20
      dataType: "json"
    ).done (groups) ->
      callback(groups)

  # Return namespaces list. Filtered by query
  namespaces: (query, callback) ->
    url = Api.buildUrl(Api.namespaces_path)

    $.ajax(
      url: url
      data:
        private_token: gon.api_token
        search: query
        per_page: 20
      dataType: "json"
    ).done (namespaces) ->
      callback(namespaces)

  buildUrl: (url) ->
    url = gon.relative_url_root + url if gon.relative_url_root?
    return url.replace(':version', gon.api_version)

  # Return LDAP groups list. Filtered by query
  ldap_groups: (query, provider, callback) ->
    url = Api.buildUrl(Api.ldap_groups_path)
    url = url.replace(':provider', provider);

    $.ajax(
      url: url
      data:
        private_token: gon.api_token
        search: query
        per_page: 20
        active: true
      dataType: "json"
    ).done (groups) ->
      callback(groups)

  # Return projects list. Filtered by query
  projects: (query, callback) ->
    project_url = Api.buildUrl(Api.projects_path)

    project_query = $.ajax(
      url: project_url
      data:
        private_token: gon.api_token
        search: query
        per_page: 20
      dataType: "json"
    ).done (projects) ->
      callback(projects)
