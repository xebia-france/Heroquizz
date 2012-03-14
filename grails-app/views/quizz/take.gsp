<head>
  <meta name="layout" content="main">
</head>

<body>
<r:require module="jwplayer"/>
<div class="row">
  <div class="span8 offset2">
    <div class="hero-unit">
      <g:if test="${questionInstance.videoUrl}">
        <div class="video-container">
          <div id='mediaplayer'></div>
        </div>
        <r:script>
    jwplayer('mediaplayer').setup({
      'flashplayer': '${resource(dir: 'flash', file: 'player.swf')}',
      'id': 'playerID',
      'width': '640',
      'autostart': false,
      'backgroundColor': 'transparent',
      'file': '${questionInstance.videoUrl}'
    });
        </r:script>
      </g:if>
      <g:else>
        <p><g:fieldValue bean="${questionInstance}" field="text"/></p>
      </g:else>

      <g:form action="answer" class="form-horizontal">
        <fieldset>
          <g:hiddenField name="currentQuestionId" value="${questionInstance?.id}"/>

          <div class="control-group">
            <label class="control-label" for="optionsCheckboxList">Votre réponse :</label>

            <div class="controls">
              <g:each in="${questionInstance.answers}" var="a">
                <label class="checkbox">
                  <g:checkBox name="answers" value="${a.id}" checked="${false}"/>
                  ${a?.text?.encodeAsHTML()}
                </label>
              </g:each>
            </div>

          </div>
        </fieldset>

        <div class="actions">
          <g:submitButton name="submit" value="Valider" class="btn primary"/>
        </div>
      </g:form>
    </div>
  </div>
</div>
</body>
</html>
