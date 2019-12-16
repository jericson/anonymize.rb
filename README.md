# anonymize.rb

A script to anonymize names in a text file.

For instance, suppose you are writing a case study and you don't want
to shame the innocent or give publicity to the guilty. But you don't
want to have to remember pseudonyms while you are writing the
document. All you need to do is wrap names you want to anonymize in
double curly brackets:

> And then {{Jon}} made the most embarrassing mistake imaginable.

If you save that case study in a file named `case_study.md`, you can
anonymize it thusly:

    $ anonymize.rb case_study.md
    And then Filiberto made the most embarrassing mistake imaginable.

If you later write:

> {{Jon}} was quite relieved that nobody blamed him for his mistake.

It will be anonymized as:

> Filberto was quite relieved that nobody blamed him for his mistake.

That way you don't need to memorize `Jon => Filberto` when writing
since anonymize.rb keeps track for you. Of course, it might not be
Filberto next time you run it. Maybe you'll end up substituting Yung
for `{{Jon}}` next time.

The script can also work with first and last names if you use an
underscore:

> It's a good thing {{Jon_Ericson}} doesn't use his full name.

If `{{Jon}}`has already been defined, the script will make the same
substation for the first name and create a new substation for
`{{Ericson}}`. This may or may not be what you want. If you want to
differentiate two people who happen to have the same name, you can add
a number or other distinguishing feature:

> {{Jon1}} hoped he wouldn't get dragged into this mess.

## Saving and loading substitutions

Getting a random substation every time stops being fun after
awhile. Sometimes you want stability. It also can be handy to have a
list of substitutions if you need to decode the anonymized
document. The script can `--save` the substitutions as a Ruby hash:

    $ anonymize.rb case_study.md -s substitutions.rb

Next time you run the script, `--load` and reuse the substitutions:

    $ anonymize.rb case_study.md -l substitutions.rb

Since you probably want to both load and save substitutions at the
same time, you could use both options or the `--cache` option:

    $ anonymize.rb case_study.md -l substitutions.rb -s substitutions.rb
    $ anonymize.rb case_study.md -c substitutions.rb

Both commands are exactly the same.

## Using rare or common names

The script uses the [Namey gem](https://github.com/muffinista/namey)
to pick a random name from the
[US Census Bureau database](https://www.census.gov/topics/population/genealogy/data/1990_census/1990_census_namefiles.html). Some of those names are a little unusual. So you can specify just the `--common` names:

    $ anonymize.rb case_study.md --common

Alternatively, you can select `--rare` names.

## Oddities

Probably the biggest oddity is that the new names won't have the same
gender associations as the originals. This can make reading more
difficult. I personally prefer to use "they" and "them" for all
pronouns when the names are going to be anonymized. That way the
pronouns work out whatever the name. But it might be preferable to
assign gender to each name.

While Namey does provide a way to select names that are commonly male
or commonly female in the data, this script doesn't support a way to
assign gender. It's more a practical consideration than a political
one; I don't want to invent a new syntax for it. There's also the
issue that the data isn't exactly binary. For instance John is #2 on
the male list (3.271%) and #819 on the female list (0.012%). So if
someone is named John, you can reasonably guess they are a man, but
you can't rule out they are a woman.

If sticking to one gender is important to you, I recommend using the
``--cache`` option and manually editing the substations file to your
liking.

Namey tries to fix the capitalization of names. Since the census
bureau encoded all the names in ALL CAPS, it munged names like
McMasters and O'Brien. 
