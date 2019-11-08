# [.node] Node entity
{{parent: ent}}

The system shall provide `Node` entity that provide the following attributes:

Attribute | Type   | Required | Default | Description
--------- | ------ | -------- | ------- | -----------
id        | String | Yes      | ""      | Node identifier
title     | String | Yes      | ""      | Node title
meta      | Hash   | Yes      | {}      | Node metadata
body      | String | Yes      | ""      | Node body
items     | Array<Node> | Yes | []      | Array of child nodes

## System node options

The system through node metadata shall provide the following system options:

Option      | Example | Description
----------- | ------- | -----------
parent      | parent: fr | specifies the node parent
skip_meta   | skip_meta: true | force the system to skip printing metadata
order_index | order_index: .1 .2 | force the system to use specified order for child nodes

# [.tt] Template entity
{{parent: ent}}

The system shall provide `Template` entity that provide the following attributes:

Attribute | Type   | Required | Default | Description
--------- | ------ | -------- | ------- | -----------
id        | String | Yes      | ""      | Template identifier
body      | String | Yes      | ""      | Template body
