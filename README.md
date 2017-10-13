# autocomplete-glossaries package

Add labels of your glossaries of your latex document to autocomplete+ suggestions
![A screenshot of your package](https://user-images.githubusercontent.com/929957/31552778-ac4387de-b038-11e7-8176-609e37f0dfea.PNG)

## Features
* complete labels for [glossaries package](https://ctan.org/pkg/glossaries) in latex
* custom prefixes for autocomplete
* displays type, text and description of glossaries entry

## Usage

> The glossaries entries definition has to be done in the document environment.

For defining acronyms and symbols for Latex documents the [glossaries
package](https://ctan.org/pkg/glossaries) is a powerful solution. If
there are a lot of entries defined, it gets hard to remember all their labels.
Therefor this package is created. But, to create a database of all defined
entries is a major issue, because there are several commands with different
syntax. In addition, in many cases custom commands are used for creating
entries. To overcome this issue the package uses the workaround of the
glossaries package when the entries not defined in the preamble. In this case a
external file (`jobname.glsdefs`) is created with all entries, which can easily parsed<sup id="a1">[1](#f1)</sup>. Thus, to use package follow these steps.

1. Define your entries within the document environment
2. Compile your latex document
3. Entries should now be suggested.

---

<b id="f1">1:</b> There are some drawbacks with defining entries in the document environment. See the [documentation](http://ctan.space-pro.be/tex-archive/macros/latex/contrib/glossaries/glossaries-user.html#sec:docdefs) of the glossaries package [↩](#a1)
