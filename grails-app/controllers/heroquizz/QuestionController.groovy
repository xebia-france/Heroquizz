package heroquizz

import org.springframework.dao.DataIntegrityViolationException

class QuestionController {

  static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

  def index() {
    redirect(action: "list", params: params)
  }

  def list() {
    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    [questionInstanceList: Question.list(params), questionInstanceTotal: Question.count()]
  }

  def create() {
    if (!params.id) {
      log.warn("Can't create question not linked to a given quizz id")
    }

    [questionInstance: new Question(params), forQuizz: Quizz.get(params.id as Long)]
  }

  def save() {
    def questionInstance = new Question(params)
    
    def ownerQuizz = Quizz.get(params.quizzId)

    questionInstance.quizz = ownerQuizz

    if (!questionInstance.save(flush: true)) {
      render(view: "create", model: [questionInstance: questionInstance])
      return
    }

    flash.message = message(code: 'default.created.message', args: [message(code: 'question.label', default: 'Question'), questionInstance.id])
    redirect(controller: 'quizz', action: "show", id: ownerQuizz.id)
  }

  def show() {
    def questionInstance = Question.get(params.id)
    if (!questionInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'question.label', default: 'Question'), params.id])
      redirect(action: "list")
      return
    }

    [questionInstance: questionInstance]
  }

  def edit() {
    def questionInstance = Question.get(params.id)
    if (!questionInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'question.label', default: 'Question'), params.id])
      return redirect(action: "list")
    }
    println "trouvé : ${questionInstance}"

    [questionInstance: questionInstance, forQuizz: questionInstance.quizz]
  }

  def update() {
    def questionInstance = Question.get(params.id)
    if (!questionInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'question.label', default: 'Question'), params.id])
      redirect(action: "list")
      return
    }

    if (params.version) {
      def version = params.version.toLong()
      if (questionInstance.version > version) {
        questionInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
            [message(code: 'question.label', default: 'Question')] as Object[],
            "Another user has updated this Question while you were editing")
        render(view: "edit", model: [questionInstance: questionInstance])
        return
      }
    }

    questionInstance.properties = params

    if (!questionInstance.save(flush: true)) {
      render(view: "edit", model: [questionInstance: questionInstance])
      return
    }

    flash.message = message(code: 'default.updated.message', args: [message(code: 'question.label', default: 'Question'), questionInstance.id])
    redirect(action: "show", id: questionInstance.id)
  }

  def delete() {
    def questionInstance = Question.get(params.id)
    if (!questionInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'question.label', default: 'Question'), params.id])
      redirect(action: "list")
      return
    }

    try {
      questionInstance.delete(flush: true)
      flash.message = message(code: 'default.deleted.message', args: [message(code: 'question.label', default: 'Question'), params.id])
      redirect(action: "list")
    }
    catch (DataIntegrityViolationException e) {
      flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'question.label', default: 'Question'), params.id])
      redirect(action: "show", id: params.id)
    }
  }
}
