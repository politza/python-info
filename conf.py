#BEGIN texinfo
# Don't remove the previous line.

 # texinfo_documents

 #    This value determines how to group the document tree into
 #    Texinfo source files. It must be a list of tuples (startdocname,
 #    targetname, title, author, dir_entry, description, category,
 #    toctree_only), where the items are:

 #        startdocname: document name that is the “root” of the
 #        Texinfo file. All documents referenced by it in TOC trees
 #        will be included in the Texinfo file too. (If you want only
 #        one Texinfo file, use your master_doc here.)
 
 #        targetname: file name (no extension) of the Texinfo file in
 #        the output directory.

 #        title: Texinfo document title. Can be empty to use the title
 #        of the startdoc. Inserted as Texinfo markup, so special
 #        characters like @ and {} will need to be escaped to be
 #        inserted literally.
 
 #        author: Author for the Texinfo document. Inserted as Texinfo
 #        markup. Use @* to separate multiple authors, as in:
 #        'John@*Sarah'.
 
 #        dir_entry: The name that will appear in the top-level DIR menu file.
 
 #        description: Descriptive text to appear in the top-level DIR menu file.
 
 #        category: Specifies the section which this entry will appear
 #        in the top-level DIR menu file.
 
 #        toctree_only: Must be True or False. If True, the startdoc
 #        document itself is not included in the output, only the
 #        documents referenced by it via TOC trees. With this option,
 #        you can put extra stuff in the master document that shows up
 #        in the HTML, but not the Texinfo output.

# All %s will be replaced with the version number.
# DON'T CHANGE THE FILENAME (2nd item).

texinfo_documents = [
    ('contents', 'python-%s', 'Python Documentation', _stdauthor,
     'Python-%s', 'The Python Documentation', 'Python'),
]
#END texinfo
