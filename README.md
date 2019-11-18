# Clerq

## What is Clerq?

The Clerq is a toolbox for manipulating the hierarchy of text data placed in separate markdown files. It implements three basic ideas:

1. Text data repository in file system, based on markdown files with few extra conventions.
2. Ruby gem that provides access to the text hierarchy from the repository.
3. Basic CLI to manage the repository and compile the text data to documents based on erb-templates.

The basic entity that the gem provides is a text node that has id, title, body, and metadata, as well as supply flexible access to the hierarchy trough the `Enumerable` interface.

You can hold anything you want in the text data, and the data is easy to access and to transform with erb templates.

## Installation

Install it yourself as:

    $ gem install clerq

## Reasons

For more than 10 years I have been working as a business analyst, systems analyst, and sometimes even as a product owner. And all these roles straightly related to user or software requirements and thick documents like RFP, Vison, URD, SRS, SAD. You can also add to the list some traceability matrix, backlogs, prioritization and estimation sheets, meeting minutes, etc.

There are a lot of requirements management systems on the market. But have you ever managed to convince your employer to buy DROOLS or Valere?

There are few familiar word processors for office documents. But have you ever tried to create and evolve a few hundred pages document in a word processor like MS Word, or you started with TEX from the beginning?

That is why some years ago I decided to create a tool for myself as a technical writer. The first attempt was failed. Then I throw all nice extra features out and concentrated on real needs. The second reincarnation the [Creq]() was released four years ago, and since then I used it in every software project that I participated.

This gem is my third and most flexible realization of the idea to hold requirements and other texts in markdown files. It is so damn flexible that it is difficult to catch the primary idea ;)

Please, let me know if you adapted the gem for any other practical purposes.

To demonstrate the Clerk in action I created the promo project, and perhaps the best way to start writing with Clerq is to copy promo content and run some commands:

    $ clerq new promo
    $ cd promo
    $ clerq promo
    $ clerq help
    % thor help promo

## Basics

The Clerk is entirely based on one single domain entity. The `Node` entity represents one node in tree hierarchy and provides such fields as `id`, `title`, `body`, and `metadata`.

The Clerq can read such nodes from a set of separate markdown files and combine it to a single hierarchy based on few additional conventions. Actually, there are two basic conventions only.

### Node file

The first convention is the scheme how a markdown content becomes the `Node` entity.

```
# [p2] Part two
{{parent: top}}

Body
```

Where

* `#` familiar markdown header that indicates a new `node`;
* `[p1]` is an optional identifier that becomes `node.id`;
* `Part two` is an optional `node.title`;
* `{{parent: top}}` in an optional metadata section that becomes `node.meta`;
* and finally `Body` is an optional `node.body`.

Every new header (`#`) at any level indicates a new node. When a file contains headers of different levels, the nodes will be created in a natural hierarchy based on header levels. So as the result of reading the content below, the Clerq will create the natural hierarchy with root node `Top` that holds two child nodes `First` and `Second`.

```markdown
# Top
## First
## Second
```

One more extra thing is links. You can place links to other nodes in the body section of the file content by using `[[<id>]]` macro. It can be handled in templates.

### Hierarchy

The second convention is just two metadata attributes that specify parameters of a hierarchy:

1. `parent: <id>` indicates that the node belongs to a node with specified `id`;
2. `order_index: <id1> <id2>` indicates that child nodes must be lined up in specified order.

## Usage

The Clerq supposes the following simple flow:

* you create files with text data,
* and manipulate the data by scripts.

### Project

The Clerq project lives in the following folders structure that will be created by `clerq new <project>`:

* `bin/` - for output documents;
* `bin/assets` - for assets;
* `knb/` - knowledge base;
* `lib/` - place for extra Ruby code;
* `src/` - source data repository;
* `tt/` - templates;
* `<project>.thor` - see [Scripting](#scripting);
* `clerq.yml` - project settings;
* `README.md`.

### CLI

Clerq provides CLI that is based on Thor, so all standard thor features are supported. To print all Clerq commands type `$ clerq help` in your console. To see the list of all the project-specific commands type `thor help <project>`.

#### Create new project

To create a new project run `new` command:

    $ clerq new <project_name>

#### Create new file

The simplest way of adding new items to the project is to add a new file to the `src` directory. Of course, Clerq also provides the command `node` that can create template-based files:

    $ clerq node ID [TITLE] [-t TEMPLATE]

__Assets__

If you are using images or other assets, you should place it to `bin/assets` directory and write markdown link like `![img](assets/img.png)`

__Templates__

You also can prepare your own templates it `tt` folder and provide template through `-t/--template` option. The content of the template will be placed on the created file.

#### Check repository

Because of lots of handwriting there can be some specific errors in repository. The most obvious are:

* non-unique identifiers;
* links to and id that does not exist:
   * for `parent` attribute;
   * in `order_index`;
   * in `body`.

The system provides command `clerq check` that will check the repository for these kinds of errors.

    $ clerq check

#### Build project

Clerq provides the ability to combine all the text data from the project repository and create the final document. To create such document you can use `clerq build` command:

    $ clerq build

It will create final document with default file name, title, and by default erb template. These default values are defined in `clerq.yml` and you should change it according to your aim.

Default values of final document parameters are:

* `document: <project_name>`;
* `template: default.md.erb`;
* `title: <project_name>`.

You also can specify these settings through `clerq build` options:

* `-t/--template TEMPLATE` provides the ability to specify template;
* `-o/--output FILE_NAME` provides the ability to specify output file name.

__Queries__

Clerq provides the ability to query data that match query criteria. To query data you should use `-q/--query QUERY_STRING` option where `QUERY_STRING` is ruby code that will test if each node matches the  `QUERY_STRING`. For example, `node.tile == 'Functional requirements'` or `node.id == 'us'`.

#### Print TOC

Sometimes it helpful to check repository structure by `clerq toc` command. The command also supports `-q/--query QUERY_STRING` option.

### Writing

There are a few more conventions that you can use in writing data that you already know from [Basics](#basics).

#### Files

Already described in [Node file](#node-file)

#### IDs

Each node must have its own unique id so that you can refer to it in other parts of the project. That's why the recommended practice is to put the id straight into the header `# [node id] node title`.

ID can start with one dot, like `[.suffix]`, and clerq will add id of parent node. For the followed example, `[.fm]` will be translated to `[cm.fm]`.

```
# 3 Function requirements
## [cm] Components
### [.fm] File manager
### Logger
```

When an id is not provided, Clerq will generate it automatically, and you can freely combine nodes that have id and that has not. For the example above, the `Logger`  will be identified as `[cm.01] Logger`.

#### Attributes

The excerpt, the text in brackets `{{ }}` that follows by the header, contains node attributes. This was already mentioned in [Hierarchy](#hierarchy) section for magic attributes `parent` and `order_index`, but you can place here anything you need to provide additional information, like status, originator, author, priority, etc. There are no limits where to place the brackets and all the following examples will be processed correctly.

```
# [r.1]
{{parent: r; skip_meta: true}}

# [r.2]
{{parent: r
skip_meta: true}}

# [r.3]
{{
parent: r
skip_meta: true
}}
```

#### Assets

If you need to add an image or some other material into a requirements body, put it in the `bin/assets` folder and specify the link. This place was chosen because output files will be placed in `bin`.

```markdown
# [ent] Entities

... the following picture shows conceptual entity relations diagram

![Image](assets/er.png)
```

### Scripting

The section assumes that you are familiar with Ruby or some other programming language.

Using the basic commands described in [CLI](#cli) section gives you just the ability to create final documents or other output. But this is just the tip of the iceberg, just the beginning, and you can do much more than that with Clerq.

A usual scenario will consist of two simple steps:

1. Get data hierarchy from the repository.
2. Do some processing of the hierarchy.

Instead of adding extra scripts files, you can write tasks to `<project>.thor` file and access to them through thor tasks `thor <project>:<your-task> [<params>]`.

#### Node class

The [Node file](#node-file) section provides the basic knowledge to understand Clerq, and now it is the right time to see the [Node class](https://github.com/nvoynov/clerq/blob/master/lib/clerq/entities/node.rb). It implements the Composite pattern.

#### Interactors

There are two standard ways to get the project repository - these are two interactors - `JoinNodes` or `QueryNodes`. Each of them returns data as [Node](#node-class). When you got the Node you have all the power of [Enumerable module](https://ruby-doc.org/core-2.6.5/Enumerable.html).

Let's invent some advanced scenario. Assume that you develop a "User requirements document" and the project policy requires that each user requirement must have the parameter called `originator` in the requirements metadata. You can add the policy to your custom build process as followed:

```ruby
require 'clerq'
include Clerk::Interactors

# Supposed that you develop thick document User requirements
#   that have lots of other text that not requirements, and
#   to get only interesting data you use the query
node = QueryNodes.(query: "node.title == 'User requirements'")
# You should skip the first node because it is just tile
miss = node.drop(1).select{|n| n[:originator].empty? }
unless miss.empty?
  errmsg = "`Originator` unknow for the following requirements:\n"
  errmsg << miss.map(&:id).join(', ')
  raise Error, errmsg
end
```

#### Root Node

There is one important point with return value from JoinNodes and QueryNodes. These will always return the root Node object. JoinNodes follows the next rules:

1. It returns the root node when the repository contains the root node.
2. It creates a new root node with the title from `title: <title>` settings options when the repository does not contain a root node.

The following example does not provide root node and it causes adding root node according to rule 2.

```
# User requirements
# Functional requirements
```

But this one provides, and root node will be `Product SRS` according to rule 1.

```
# Product SRS
## User requirements
## Functional requirements
```

The QueryNodes will return the Node object in the same logic as JoinNodes. When a query returns one node - this node will be root node. When a query returns more than one, it will create a new Node with the title `Query`.

### Automating

In the project folder you can find `<project>.thor` file. This file is created here encourage you to create some automation code that can be accessed through `thor <project>:<taks>` command. You can find some examples of such tasks in [promo.thor](https://github.com/nvoynov/clerq/blob/master/lib/assets/promo/promo.thor)

### Templating

To customize Clerq output the system provides `erb` templates. You have a lot of possibilities here if you are familiar with Ruby.

Clerq provides two basic templates from the box - [default.md.erb](https://github.com/nvoynov/clerq/blob/master/lib/assets/tt/default.md.erb) and [pandoc.md.erb](https://github.com/nvoynov/clerq/blob/master/lib/assets/tt/pandoc.md.erb).

The first one just combines all nodes to one document with no changes. The second one provides some macros for processing nodes body:

* `{{@@list}}` - replaces the macro with the list of child requirements;
* `{{@@tree}}` - replaces the macro with the tree of child requirements;
* `{{@@skip}}` - skip all content inside the brackets.

`pandoc.md.erb` generates Pandoc markdown and can be used to convert the output of the template in any supported format. You also can use relative requirements links here. An example of using Pandoc to generate `docx` can be found in [Promo](#promo).

### Several artifacts

Because Clerq has `-q/--query QUERY_STRING` option you can be interested in developing several different artifacts in one project. User requirements, software requirements, and architecture as an example.

I was considering such a use case but decided that it is more properly to develop a single artifact per project because usually, each artifact has its own develop-review-release cycle.

Also, I was considering to add some kind of a "top" project that is just a wrapper for individual projects inside (each of them is the clerq project, and the top project just provides a specific set of commands.) I was speculating about some kind of shared content and tracing nodes between different artifacts. But for the moment I have no full-fledged vision.

## Known issues

### Failed test

Some tests of CLI fail by `$ bundle exec rake test` but pass individually one by one through `$ bundle exec rake test TEST=test/cli/cli_build_spec.rb` and I haven't caught the reason.

### Thor version

The one issue I certain in is when you are using different version of thor, your custom scripts won't work.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nvoynov/clerq.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
