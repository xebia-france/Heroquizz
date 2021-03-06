<%@ page import="heroquizz.Question" %>
<!doctype html>
<html>
<head>
  <meta name="layout" content="main">
  <g:set var="entityName" value="${message(code: 'question.label', default: 'Question')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>

<div class="row">
  <div class="span12">
    <ul class="breadcrumb">
      <li>
        <g:link controller="quizz" action="show" id="${questionInstance.quizz.id}">${questionInstance.quizz.name}</g:link>
        <span class="divider">/</span>
      </li>
      <li class="active">
        <a href="#"><g:message code="default.show.label" args="[entityName]"/></a>
      </li>
    </ul>
  </div>
</div>

<div class="row">
  <div class="span12">
    <legend><g:message code="default.show.label" args="[entityName]"/></legend>
    <g:if test="${flash.message}">
      <div class="message" role="status">${flash.message}</div>
    </g:if>
    <ol class="property-list question">

      <g:if test="${questionInstance?.text}">
        <li class="fieldcontain">
          <span id="text-label" class="property-label"><g:message code="question.text.label" default="Text"/></span>

          <span class="property-value" aria-labelledby="text-label"><g:fieldValue bean="${questionInstance}"
                                                                                  field="text"/></span>

        </li>
      </g:if>

      <g:if test="${questionInstance?.videoUrl}">
        <li class="fieldcontain">
          <span id="videoUrl-label" class="property-label"><g:message code="question.videoUrl.label"
                                                                      default="Video Url"/></span>

          <span class="property-value" aria-labelledby="videoUrl-label"><g:fieldValue bean="${questionInstance}"
                                                                                      field="videoUrl"/></span>

        </li>
      </g:if>

      <g:if test="${questionInstance?.answers}">
        <li class="fieldcontain">
          <span id="answers-label" class="property-label"><g:message code="question.answers.label"
                                                                     default="Answers"/></span>

          <g:each in="${questionInstance.answers}" var="a">
            <span class="property-value" aria-labelledby="answers-label"><g:link controller="answer" action="show"
                                                                                 id="${a.id}">"${a?.text?.encodeAsHTML()}" => ${a?.pointsNumber}</g:link></span>
          </g:each>

        </li>
      </g:if>

    </ol>
    <g:form>
      <fieldset>
        <div class="form-actions">
          <g:hiddenField name="id" value="${questionInstance?.id}"/>
          <g:link class="btn btn-primary" action="edit" id="${questionInstance?.id}"><g:message code="default.button.edit.label"
                                                                                     default="Edit"/></g:link>
          <g:link class="btn btn-info" controller="answer" action="create" id="${questionInstance?.id}">Add answer</g:link>
          <g:actionSubmit class="btn btn-dark" action="delete"
                          value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                          onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
        </div>
      </fieldset>
    </g:form>
  </div>
</div>
</body>
</html>
