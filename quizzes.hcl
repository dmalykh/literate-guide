# ==============================================================================
# quizzes.hcl — quizzes and questions.
# ==============================================================================

# Source: /reference/content/quiz/singlechoicequestion/ — "Basic Geography Question"
resource "single_choice_question" "geography_basic" {
  question = "What is the capital of Japan?"
  answer   = "Tokyo"

  distractors = [
    "Osaka",
    "Kyoto",
    "Hiroshima"
  ]
}

# Source: /reference/content/quiz/singlechoicequestion/ — "Question with Hints"
resource "single_choice_question" "networking_advanced" {
  question = "Which HTTP status code indicates a successful request?"
  answer   = "200"

  distractors = [
    "404",
    "500",
    "302"
  ]

  hints = [
    "This is a 2xx status code",
    "It's the most common success status code"
  ]

  tags = ["http", "networking", "status-codes"]
}

# Source: /reference/content/quiz/multiplechoicequestion/ — "Practical Application Question"
resource "multiple_choice_question" "docker_commands" {
  question = "Which Docker commands can be used to view running containers?"

  answer = [
    "docker ps",
    "docker container ls"
  ]

  distractors = [
    "docker images",
    "docker logs",
    "docker exec"
  ]

  hints = [
    "These commands list active containers",
    "One is the newer syntax, one is the classic syntax"
  ]

  tags = ["docker", "commands", "containers"]
}

# Source: /reference/content/quiz/textanswerquestion/ — "Command Usage Question"
resource "text_answer_question" "docker_command" {
  question = "What Docker command lists all running containers?"
  answer   = "docker ps"

  exact = true

  tags = ["docker", "commands"]
}

# Source: /reference/content/quiz/textanswerquestion/ — "Simple Definition Question"
resource "text_answer_question" "define_pod" {
  question = "What is a Pod in Kubernetes?"
  answer   = "smallest deployable unit"

  tags = ["kubernetes", "concepts", "pods"]
}

# Source: /reference/content/quiz/numericanswerquestion/ — "Exact Value Question"
resource "numeric_answer_question" "kubernetes_port" {
  question = "What is the default port for the Kubernetes API server?"
  answer   = 6443

  tags = ["kubernetes", "networking", "api"]
}

# Source: /reference/content/quiz/quiz/ — "Basic Knowledge Check" (question set
# adapted to the questions defined in this file).
resource "quiz" "docker_basics" {
  questions = [
    resource.single_choice_question.geography_basic,
    resource.multiple_choice_question.docker_commands
  ]
}

# NOTE (docs finding): the quiz reference's `questions` field row lists
# true_false_question, match_question, sequence_question,
# fill_in_the_blanks_question and drag_words_question as accepted types, and the
# validator does know all five — but none of them has a reference page, and the
# page's "Supported Question Types" table claims only four types exist.
resource "true_false_question" "docs_check" {
  question = "Instruqt labs are configured in HCL."
  answer   = true
}

# Source: /reference/content/quiz/quiz/ — "Comprehensive Assessment" (one question
# of every documented type plus the undocumented true/false type, with
# show_hints / show_answers).
resource "quiz" "final_exam" {
  questions = [
    resource.single_choice_question.networking_advanced,
    resource.multiple_choice_question.docker_commands,
    resource.text_answer_question.docker_command,
    resource.text_answer_question.define_pod,
    resource.numeric_answer_question.kubernetes_port,
    resource.true_false_question.docs_check
  ]

  show_hints   = true
  show_answers = true
}
