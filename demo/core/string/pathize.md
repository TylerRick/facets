## String#pathize

    require 'facets/string/pathize'

module name

    a = "Foo::Base"
    x = "foo/base"
    a.pathize.assert == x

path name

    a = "foo/base"
    x = "foo/base"
    a.pathize.assert == x

name space

    a = "foo__base"
    x = "foo/base"
    a.pathize.assert == x

