Busca
====

Busca is a simple redis search. Nothing more, nothing less.

Description
-----------

Busca is a simple redis search that uses bitmaps to index words and performs searches. It is NOT recommended for your *big data*, unless you have *big <sup>big</sup> memory*. Also, there are no tests (yet) of how it performs with a that *big data* (if you are feeling adventurous, let me know).

## Installation

As usual, you can install it using rubygems.

```
$ gem install busca
```

## What kind of sorcery is this?

Well, that's a fair question. Busca is a ruby gem that indexes text and perform searches. It does that using redis as a backend, which is nice, because redis is nice.

To be honest, I have no idea how a fulltext search works, but I'm pretty sure it's complex. Busca is simple and works (at least for me).

It started as a proof of concept, and *it's still* a proof of concept, but running in production in a couple of tiny sites.

## Before usage

Busca works (more or less) like this:

* You create a new instance of Busca, something like `busca = Busca.new`
* You pass some *identifier* (more on this later) and a string to the `index` function. Something like `busca.index(101, "Hey, please index this fancy text for me, will you?")`
* Then, you search, like `result = busca.search("fancy")`

That's it. `result` now contains an array of the *identifiers* that contain the word "fancy".

This is pretty much it. Internally, however, a few things happen.

`Busca` uses two gems:

* [Separa](https://github.com/Porta/separa) splits the input (a string, an object, you name it) into an array of terms.
* [Filtra](https://github.com/Porta/filtra) filters that array (removing duplicates, stemming, changing case, removing stopwords) to only index the terms you really want to index and make a effective use of space.

While those gems are included in `Busca` and used by default, you're not tied to them. You can implement your own separator and filter based on your particular scenario. Feel free to check the docs of both in order to get an idea of what they do and how.

Overall, this is the flow:

#### Index:

* You create a new instance of `Busca`. This is where you pass any configuration.

* Then, you `index` something. A unique identifier is required first (in most cases, the id of whatever you're indexing, so you can retrieve it from it's store later). Then, whatever you want to index. It can be a string or a ruby object.

* `Busca` receives whatever you passed to index and passes that to the separator.

* Then, the resulting array is passed to the filter.

* The resulting array is then indexed (saved into redis).

### Search

* With your instance of `Busca`, you call the `search` method with whatever you want to search for (string or object)

* Busca passes that through the same separator and filter used in the indexing process.

* The result is an array with the identifiers you passed on the indexing process.

* Done!

## Usage

### Index/search a string

```ruby
    document = <<-eos
Ay, marry, is't:
But to my mind, though I am native here
And to the manner born, it is a custom
More honour'd in the breach than the observance.
This heavy-headed revel east and west
Makes us traduced and tax'd of other nations:
They clepe us drunkards, and with swinish phrase
Soil our addition; and indeed it takes
From our achievements, though perform'd at height,
The pith and marrow of our attribute.
eos

busca = Busca.new
indexed_id = busca.index(123, document) #indexed_id return id assigned in the index.
                                        #not especially relevant, but in case you need it for something
#... later on
result = busca.search("breach")
result == [123] #the identifier of the document.
```











