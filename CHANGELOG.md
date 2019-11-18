# Change log

## master (unreleased)

The main purpose of the gem was changed to more general <u>text nodes repository management</u>. The requirements management still my original reason, but it is achieved rather through adjustment than by basic features. That way was updated descriptions in `gemspec` and the repository.

According to this big shift, I'm planning to record a few basic videos "How to write big documents with Clerq". At the moment I created the clerq project [Clerq Video Guide](https://github.com/nvoynov/clerq-video-guide) and the first script. You can just download this at [Clerq Video Guide.pdf](https://github.com/nvoynov/clerq-video-guide/blob/master/bin/Clerq Video Guide.pdf). I hope I'll have time to create an episode on how to meet requirements management challenges.

Changes:

   * Improved `JoinNodes.call()`. When the result node contains the only single child item, it will return the child item orphaned.
   * Improved `clerq new PROJECT` command. When the `PROJECT` parameter consists of more than one word, It will create `<project>.thor` file that follows to usual ruby file and class naming conventions; e.g. for `user guide` it will create `user_guide.thor` and `class UserGuide < Thor` inside.
   * Thor `error(msg)` in `cli.rb` changed to `stop!(mgs); raise Thor::Error`.
   * Improved CLI for `build`, `check`, `toc`; now these check if the command run in clerq project, checked if `clerq.yml` or `src` folder exist.
   * Added `cli_node_spec.rb` stub 

## 0.1.0 (2019-11-08)

First release
