# TODO

[ ] Return node file name from NodeRepository and CreateNode
[ ] Check Node carefully and move stuff to MarkupNode of templates; maybe provide MarkupNode to lib for new projects?
[ ] GitHub Pages! Architect or Hacker template
[ ] Add spec to `clerq node`
[ ] Remove handling `skip_meta` from `default.md.erb`
[ ] Release v0.2.0

# Refactoring

* Added FileRepository and TextRepository, that replaces TemplatesRepository
* Added QueryTemplate interactor that returns template content. It provides the ability to match templates in subfolders by name without extension
* Modified Clerq added text_template and text_template= methods
* Refactored NodeRepository: only two visible methods `save` and `assembly`
* Gateways, Template removed

## Interactors

Which interactors remains?

* JoinNodes - replaced NodeRepository.assemble. Is there any need to remain? Don't think so... maybe AssembleNodes или он просто получает и все ..., that just the interface to NodeRepository.assemble
* QueryNodes

CreateNode
QueryTemplate
QueryAssembly
CheckAssembly
BuildDocument
BuildTemplate
RenderNodeErb.('erb')

## Render

I'm not satisfied with the `build` command and the `CompileNodes` interactor. These smells because an interactor must give some final result itself and command must call interactor.

How about the following?

1. To provide interactor `RenderNode.(output: , template: , query: )` that will produce output in `bin` folder.
2. To use the interactor in `build` command, and to consider the `build` later.
3. To rename the `Templater` as `ErbRenderer`  

## Templates

The first reason is that I do not see the need to have a separate entity for templates. Templates are just pieces of text, and all required is to get templates text by the filename.

The NodeRepository class smells because is does extra work that is nowhere needed, and does it dirty (why it loads all templates in memory?)

So I want to do the following refactoring here

1. NodeRepository provides only one function - return template content from file by its filename.
2. Provide QueryTemplate interactor that returns template content of fails when template not found.

## Gateway

Gateway has to gone because it also smells. The vision is that there two connected things - repositories and interactors. Each interactor uses just one entity repository, and all extra work with other entities must be done through other interactors.

So I want to do the following changes:

1. Remove Gateways and provide functions to get repositories for node and template - `Clerq.node_repository`, `Clerq.blob_repository`.

## NodeRepository

Just extract some methods
