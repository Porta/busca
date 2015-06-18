require File.expand_path("../lib/busca", File.dirname(__FILE__))  

scope do
  setup do
      document = "this is some document that I've indexed"
      busca = Busca.new()
      busca.redis.call('flushdb')
      [busca, document]
  end

  test "delete a document from index" do |busca, document|
    first = busca.index(4, document)
    second = busca.index(5, 'My name is julian porta and Im a good person')
    busca.remove(second)
    assert_equal busca.redis.call('GET', 'Busca:document:1'), "4"
    assert_equal busca.redis.call('GET', 'Busca:document:2'), nil
  end

  test "should vacant an id upon document deletion" do |busca, document|
    first = busca.index(11, document)
    second = busca.index(12, 'My name is julian porta and Im a good person')
    busca.remove(second)
    assert_equal busca.redis.call('GET', 'Busca:document:2'), nil
    assert_equal busca.redis.call('LINDEX', 'Busca:vacants', 0), "2"
  end

  test "should use the vacant id on new document index" do |busca, document|
    first = busca.index(13, document)
    assert_equal busca.redis.call('GET', 'Busca:document:1'), "13"
    busca.redis.call('RPUSH', 'Busca:vacants', 3)
    second = 'My name is julian porta and Im a good person'
    busca.index(14, second)
    assert_equal busca.redis.call('GET', 'Busca:document:3'), "14"
  end
end