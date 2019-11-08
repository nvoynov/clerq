# [.writer] Writer
{{parent: cmp}}

The system shall provide the `Writer component`. The component shall provide functions of writing requirements repository to markup text.

## [.write] Write function

The `Writer` component shall provide the function `write`.

__Input__

Parameter | Type | Required | Description
--------- | ---- | -------- | -----------
node      | Node | Yes | see [[ent.node]]
template  | Template | Yes | se [[ent.tt]]

__Output__

Text presentation of `node` parameter according to `template` parameter
