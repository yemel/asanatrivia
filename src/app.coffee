ASANAS = window._ASANAS
app    = angular.module 'asanaTrivia', [ 'ngRoute' ]

# -------------
# Object model:

class Question
  constructor: (candidates, @answer) ->
    incorrect = _.without candidates, @answer
    @options  = _.shuffle _.sample(incorrect, 3).concat [@answer]


class Trivia
  constructor: (question_asanas, answer_candidates) ->
    @reset question_asanas, answer_candidates

  reset: (@question_asanas, @answer_candidates) ->
    @order = _.shuffle @question_asanas

    @total    = @question_asanas.length
    @answered = 0
    @correct  = 0

    @ongoing = true
    @next()

  next: ->
    if @order.length > 0
      @question = new Question @answer_candidates, @order.pop()
    else
      @ongoing = false

  choose: (answer) ->
    return if not @ongoing

    @answered++
    @correct++ if answer.name is @question.answer.name
    
    @next()


# -----------------------
# Angular trivia service:

app.service 'trivia', ->
  new Trivia ASANAS, ASANAS # The service is a Trivia instance itself


# ---------------
# Angular routes:

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'tpl/home.html'
      controller : 'Home'
      
    .when '/trivia',
      templateUrl: 'tpl/trivia.html'
      controller : 'Trivia'

    .when '/results',
      templateUrl: 'tpl/results.html'
      controller : 'Results'

    .otherwise redirectTo: '/trivia'
]


# --------------------
# Angular controllers:

app.controller 'Home', ($scope, $location) ->


app.controller 'Trivia', [ '$scope', '$location', 'trivia',

  ($scope, $location, trivia) ->
    trivia.reset _.sample(ASANAS, 4), ASANAS

    $scope.trivia = trivia

    $scope.choose = (index) ->
      $scope.trivia.choose $scope.trivia.question.options[index]

      if not $scope.trivia.ongoing
        $location.path '/results'
]


app.controller 'Results', [ '$scope', '$location', 'trivia',

  ($scope, $location, trivia) ->
    $scope.trivia = trivia
]
