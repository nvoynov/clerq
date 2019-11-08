# CReq Promo

The purpose of this project is the "Clerq promotion by examples" of writing the SRS for Clerq using the Clerq.

* [Repository](#repository)
* [CLI](#cli)
* [Promo CLI](#promo-cli)

## Repository

The project has the following folders structure:

* `bin/` - for output documents;
* `bin/assets` - for any assets provided by the documents;
* `knb/` - place here any helpful information;
* `lib/` - place for custom Ruby code;
* `src/` - place for requirements;
* `tt/` - place for templates;
* `clerq.yml` - the project settings;
* `promo.thor` - the project automating tasks;
* `README.md` - this file.

## CLI

You can see a list of all clerq commands by `clerq help` and get help of a certain command by `clerq help <commmand>`.

Play with CLI, type some commands and see results.

    $ clerq help
    $ clerq help chk
    $ clerq check
    $ clerq build
    $ clerq node
    $ clerq toc

## Promo CLI

Clerq CLI s based on the `Thor` gem and you can extend it according to your specific needs. For this purpose, you should use `promo.thor`. And to see all the Promo tasks you can just type `thor list promo` or `thor help promo`.

`promo.thor` contains just one simple example creating Microsoft Word document by converting Clerq document to .docx by using `Pandoc`.
