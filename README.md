# Clerq

Gem `clerq` represents an unusual but effective way of writing and managing requirements. It resembles some static site builders and was inspired by those. Actually this gem provides the ability to write requirements in separate files and combine those to a unified consistent requirements source for any future purposes.

Sounds too simple? Combine it with a modern text editor that supports markdown, place repository under `Git`, install `Pandoc` to convert it to any supported format. Create your own commands through `Thor` to automate every piece of work that can be automated. Give it a try!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clerq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clerq

## Usage

To see the list of all standard clerq commands type in console `clerq help` and follow the printed instructions.

To see the list of all specific for the project  commands type `thor help <project>`

Actually the best way to start with Clerq is to see it in action through [Promo](#promo). Just start from copying promo content and running some commands.

### Creating new project

To create a new project run `new` command:

    $ clerq new <project_name>

### Create new item

The simplest way of adding new items to the project is to add a new file to the `src` directory. Of course, Clerq also provides the command `node`

    $ clerq node ID [TITLE] [-t TEMPLATE]

__Assets__

If you are using images or other assets, you should place it to `bin/assets` directory and write markdown link like `![img](assets/img.png)`

__Templates__

You also can prepare your own templates it `tt` folder and provide template through `-t/--template` option. The content of the template file will be placed on the body of the requirement.

### Check repository

Because of lots of handwriting there can be some specific errors in repository. The most obvious are:

* non-unique requirements identifiers;
* links to and id that does not exist:
   * for `parent` attribute;
   * in `order_index`;
   * in `body`.

The system provides command `clerq check` that will check the repository for these kinds of errors.

    $ clerq check

### Build project

Clerq provides the ability to combine all requirements from the project repository and create final document. To create such document you can use `clerq build` command:

    $ clerq build

It will create final document with default file name, title, and by default erb template. These default values are defined in `clerq.yml` and you should change it according to your aim.

Default values of final document parameters are:

* `document: <project_name>`;
* `template: default.md.erb`;
* `title: <project_name>`.

You also can specify these settings through `clerq build` options:

* `-t/--template TEMPLATE` provides the ability to specify template;
* `-o/--output FILE_NAME` provides the ability to specify output file name.

__Query requirements__

Clerq also provides ability to query requirements that meet query criteria. To query requirements you should use `-q/--query QUERY_STRING` where `QUERY_STRING` is ruby code that will test if each node meets the  `QUERY_STRING`. For example, `node.tile == 'Functional requirements'` or `node.id == 'us'`.

### Print TOC

Sometimes it helpful to check repository structure by `clerq toc` command. The command also supports `-q/--query QUERY_STRING` option.

## Known issues

### Failed test

Some tests of CLI fail by `$ bundle exec rake test` but pass individually one by one through `$ bundle exec rake test TEST=test/cli/cli_build_spec.rb` and I haven't caught the reason.

### Thor version

The one issue I certain in is when you are using different version of thor, your custom scripts won't work.

## Structure

### Project

The Clerq project has the following folders structure by default (that will be created by `clerq new <project>`):

* `bin/` - for output documents;
* `bin/assets` - for assets;
* `knb/` - knowledge base;
* `lib/` - place for Ruby code;
* `src/` - place for requirements;
* `tt/` - templates;
* `<project>.thor` - file with automated tasks (see more in [Automating](#automating));
* `clerq.yml` - project settings;
* `README.md`.

### Repository

Place requirements to the `src` folder. You can group your requirements by different folders and subfolders - Clerq load all the files of `src` including all subfolders at any level of nesting.

### Node

Each requirement is a markdown file with a few additional compliances (will be explained below) where every file can contain any number of requirements. Let's meet some files ...

**content.md**

```markdown
# 1 Introduction
{skip_meta: true}
## 1.1 Purpose
## 1.2 Scope
## 1.3 References
## 1.4 Definitions
## 1.5 Overview
# [f] Requirements
# [i] Interfaces
# [n] Non-functional requirements
# [c] Design constraints
```

**fm.md**

```markdown
# [.fm] File manager
{{parent: f}}

The system shall provide the `File Manager` component. The component shall provide the following features:

{{@@list}}

## Read folders structure
## Read file content
## Load ".md"
## Load ".tt"
```

#### Headers

Every requirement starts with markdown header. All the text between headers belongs to the requirement.

#### Identifiers

Each requirement must have its own unique identifier so that you can refer to it in other parts of the project. That's why the recommended practice is to put id straight into the header `# [requirement_id] requirement title`.

ID can start with one dot, like `[.suffix]`, and clerq will add parent requirement id before. For the followed example, `[.fm]` will be translated to `[cm.fm]`.

```
# 3 Function requirements
## [cm] Components
### [.fm] File manager
### Logger
```

When an identifier is not provided, Clerq will generate it automatically, and you can combine requirements that have id and requirements that does not. For the example above, the `Logger`  will be identified as `[cm.01] Logger`.

#### Attributes

The excerpt, the text in brackets `{{ }}` that follows by the header, contains requirement attributes. You can place here anything you need to provide additional information, like status, source, author, priority, etc. All the following examples are correct.

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

The next attributes are **system attributes** and these influence to Clerq behavior:

* `order_index: feature1 feature2` will sort child requirements in provided order;
* `parent: f` will place the requirement as a child of parent requirement `[f]`.

All other attributes (`status`, `source`, etc.) are **user attributes** and do not influence Clerq behavior. These attributes are holding in requirement's attributes and can be used for publishing or automation purpose. One of such `skip_meta: true` used producing output document.

#### Assets

If you need to add an image or some other material into a requirements body, put it in the `bin/assets` folder and specify the link

```markdown
# [ent] Entities

... the following picture shows conceptual entity relations diagram

![Image](assets/er.png)
```

### Templating

To customize Clerq output the system provides `erb` templates. You have a lot of possibilities here if you are familiar with Ruby. Clerq distributions provides two basic templates - `default.md.erb` and `pandoc.md.erb`.

The first one combines all requirements to one document and there no requirements transformation actually.

The second one has a lot of features and provides a good example of how to add new features in the requirements body. It handles three macros:

* `{{@@list}}` - replaces the macro with the list of child requirements;
* `{{@@tree}}` - replaces the macro with the tree of child requirements;
* `{{@@skip}}` - skip all content inside the brackets.

`pandoc.md.erb` generates Pandoc markdown and can be used to convert the output of the template in any supported format. You also can use relative requirements links here. An example of using Pandoc to generate `docx` can be found in [Promo](#promo).

### Automating

You can and should extend the standard Clerq CLI by your own commands. See `<project>.thor` file as an example and call for action. It is all the Ruby code and the main point is to get requirements collection and then transform it to anything you want. It is the `Thor` gem that does all work related to CLI.

You can find some examples of custom automating in [Promo](#promo), and I hope to provide some more examples in the future.

## Promo    

The clerq provides the promotion project `promo` than contains requirements to the clerq. You can copy the `promo` content to the current clerq repository by `clerq promo` command.

The promo provides few specific commands that created to show you the way how to extend clerq. See `promo.thor` for details.

## History

During 4 years work for my previous employer I participated in dozen software development and software reengineering projects and developed dozen bulk SRS and SAD documents. All those documents were developed in MS Word as a corporate standard format for all project documentation. And every of those often cause some headache usually with casual losses of style formatting or dead halt of Microsoft Word.

When I left the employer, I decided to create a small toolkit for writing software documentation. The idea was to hold requirements in Yaml, each item in a separate file, and to provide reach features for effort estimation and prioritizing based on requirements. The first attempt was failed but brought some output. Throw out extra features! One item per file is a hell to author (but for a developer it was rather practical).

As the result of the first fail, the gem `Creq` was born. Exra features were thrown out. An author not limited to Yaml and uses Markdown now; he can write as many topics as he wants in one file. And for my new employer all requirements were developed in Creq. Some lessons were learn, some peculiarities were met, and then I decided to do some reengineering and developed Clerq. So here we are and now I have no claims to the subject of requirements writing and management.

* One Clerq project per one document!
* Document versioning and authors collaboration are under Git!
* Any text editor is suitable for requirements writing! Of course, markdown syntax highlighting feature is desired.
* Single consistent requirements source and many templates for final documents (I like to left "TBD", "TODO" and other comment for myself, reviewer, and developers but it cannot be left in documents releases.)
* All extra repeated job for certain project can be automated through Thor.

The last thing should be mentioned is drifting the original purpose of requirements management to compilation bulk documents from small pieces, and a requirement here is just a piece of text that can express just anything.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nvoynov/clerq.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
