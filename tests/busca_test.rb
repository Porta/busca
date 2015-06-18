
scope do
    setup do
        document = "this is some document that I've indexed"
        busca = Busca.new()
        busca.redis.call('flushdb')
        [busca, document]
    end

    test "index a document and get it's id" do |busca, document|
    document_id = busca.index(5, document)
    assert_equal document_id, 1
    end

    test "index two documents" do |busca, document|
        first = busca.index(3, document)
        second = busca.index(7, "uno dos tres cuatro cinco seis")
        assert_equal first, 1
        assert_equal second, 2
    end

    test "trying a more complex separator" do |a, b|
        separa = Separa.new(regexp: /,/)
        busca = Busca.new(separa: separa)
        document = "hey,there,this,is,sparta"
        document_id = busca.index(1, document)
        assert_equal 1, document_id
        another_document = "i,cannot,believe,in,sparta"
        busca.index(2, another_document)
        sparta = busca.search("sparta")
        assert_equal [1,2], sparta
    end

    test "trying a more complex document" do |a, b|
        separa = Separa.new(Separa::Obj)
        busca = Busca.new(separa: separa)
        document = {uno: 'uno', dos: 'dos', tres: {cuatro: 4, cinco: 'SINCO'}}
        document_id = busca.index(1, document)
        assert_equal 1, document_id
        cinco = busca.search(dos: 'dos')
        assert_equal [1], cinco

    end

end