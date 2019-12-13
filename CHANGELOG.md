# Change log

## 0.3.1 (2019-12-13)

* Fixed error with reading files that read attributes to body.
* Added `mm` command to `<project>.thor` that creates "Meeting Minutes" files in `<project>/mm` folder. 

## 0.3.0 (2019-12-04)

* Meet services instead of interactors. All interactors removed and their responsibility moved to appropriate services.
* Refactored printing information about repository loading progress. Now `ReadNode.call(on_error: )` accepts `on_error` callback and you can provide any method proc or lambda there like `lambda {|err| puts err}`.
* Refactored previous behavior where interactors loaded repository by QueryAssembly interactor. Now it is responsibility of `LoadAssembly` service and other services that require repository just get it through parameter.
* `clerq new PROJECT` command brings the `lib\clerq_doc.thor` example of publishing and importing existing documents in the current clerq project repository. To see these just copy the file to root project folder near `<project>.thor` file.

## 0.2.1 (2019-11-29)

* Enhanced the `Node` class that brings the possibility to provide node id through `{{id: <id>}}` metadata attribute. But it will just skipped when id is already provided by `# [<id>]`.
* Enhanced `NodeReader` class; now it supports three metadata attributes delimiters - `\n`, `;`, and `,` that can be mixed.
* `CheckAssembly` interactor replaced by `CheckAssembly` service that provides improved error information with nodes ids and source files names.
* `file_name` attribute changed to `filename` in `NodeReader`.

## 0.2.0 (2019-11-23)

* Started new project [Clerq Video Guide](https://github.com/nvoynov/clerq-video-guide) that provides example of using Clerq.
* Done massive refactoring of source code; no more gateways.
* Totally redesigned NodeRepository and TextRepository.
* Improved interactors caused by gateways throwing out.
* Improved tests suite; no more DEPRECATED Minitest; Dir.mktmpdir is used for sandbox.
* Improved README to include all the changes mentioned before.
* Improved `clerq new PROJECT` command; when the `PROJECT` parameter consists of more than one word, it will create `<project>.thor` file that follows to usual ruby file and class naming conventions; e.g. for `user guide` it will create `user_guide.thor` and `class UserGuide < Thor` inside.
* Shortened `content.md.tt` content
* Only two templates in the box are left - `default.md.erb` and `pandoc.md.erb`.
* Thor `error(msg)` in `cli.rb` changed to `stop!(mgs); raise Thor::Error`.
* Improved CLI for `build`, `check`, `toc`, `node`; now each one checks if the command is running in clerq project, checked if `clerq.yml` or `src` folder exist.
* Other small improvements.

## 0.1.0 (2019-11-08)

First release
