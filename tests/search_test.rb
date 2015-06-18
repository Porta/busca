scope do

  setup do
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
So, oft it chances in particular men,
That for some vicious mole of nature in them,
As, in their birth--wherein they are not guilty,
Since nature cannot choose his origin--
By the o'ergrowth of some complexion,
Oft breaking down the pales and forts of reason,
Or by some habit that too much o'er-leavens
The form of plausive manners, that these men,
Carrying, I say, the stamp of one defect,
Being nature's livery, or fortune's star,--
Their virtues else--be they as pure as grace,
As infinite as man may undergo--
Shall in the general censure take corruption
From that particular fault: the dram of eale
Doth all the noble substance of a doubt
To his own scandal.
    eos
    compare = <<-eos
Angels and ministers of grace defend us!
Be thou a spirit of health or goblin damn'd,
Bring with thee airs from heaven or blasts from hell,
Be thy intents wicked or charitable,
Thou comest in such a questionable shape
That I will speak to thee: I'll call thee Hamlet,
King, father, royal Dane: O, answer me!
Let me not burst in ignorance; but tell
Why thy canonized bones, hearsed in death,
Have burst their cerements; why the sepulchre,
Wherein we saw thee quietly inurn'd,
Hath oped his ponderous and marble jaws,
To cast thee up again. What may this mean,
That thou, dead corse, again in complete steel
Revisit'st thus the glimpses of the moon,
Making night hideous; and we fools of nature
So horridly to shake our disposition
With thoughts beyond the reaches of our souls?
Say, why is this? wherefore? what should we do?
    eos
    control = <<-eos
This is a control string
    eos
    chongo = <<-eos
Grace is here
    eos
    busca = Busca.new()
    busca.redis.call('flushdb')

    [busca, document, compare, control, chongo]
  end

  test "search a document" do |busca, document, compare, control, chongo|
    first = busca.index(1, document)
    second = busca.index(2, compare)
    third = busca.index(3, control)
    fourth = busca.index(4, chongo)
    result = busca.search('grace')
    assert_equal result, [1, 2, 4]
  end
  
end