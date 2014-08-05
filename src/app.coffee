ASANAS = window._ASANAS
app    = angular.module 'asanaTrivia', [ 'ngRoute' ]

# -------------
# Object model:

class Question
  constructor: (candidates, @answer) ->
    incorrect = _.without candidates, @answer
    @options  = _.shuffle _.sample(incorrect, 3).concat [@answer]


class Trivia
  constructor: (@question_asanas, @answer_candidates) ->
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

app.service 'triviaService', ->
  restart: ->
    # Create a trivia of 20 random questions, with all of the asanas as possible
    # answer candidates:
    @trivia = new Trivia _.sample(ASANAS, 5), ASANAS


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


app.controller 'Trivia', [ '$scope', '$location', 'triviaService',

  ($scope, $location, triviaService) ->
    triviaService.restart()
    $scope.trivia = triviaService.trivia

    $scope.choose = (index) ->
      $scope.trivia.choose $scope.trivia.question.options[index]

      if not $scope.trivia.ongoing
        $location.path '/results'
]


app.controller 'Results', [ '$scope', '$location', 'triviaService',

  ($scope, $location, triviaService) ->
    if not triviaService.trivia
      $location.path '/'
      return

    $scope.trivia = triviaService.trivia

]
