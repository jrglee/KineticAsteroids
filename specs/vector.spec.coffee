define ['cs!vector'], (Vector) ->

  describe 'Vector', ->
    it 'should be defined', ->
      expect(Vector).not.toBeNull()

    describe 'instance', ->

      vec = null

      beforeEach -> vec = new Vector

      it 'should have x and y', ->
        expect(vec.x).toEqual 0
        expect(vec.y).toEqual 0

