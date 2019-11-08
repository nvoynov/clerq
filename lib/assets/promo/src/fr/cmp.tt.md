# [.tt] Templates manager
{{parent: cmp}}

The system shall provide `Template manager` component. The component shall provide the following functions:

{{@@list}}

## [.find] Find template

The system shall provide function `find` for templates

__Input__

Parameter | Type   | Required | Description
--------- | ------ | -------- | -----------
id        | String | Yes      | Template identifier

__Output__

Template body (see [[ent.tt]]) by provided template `id` parameter.
