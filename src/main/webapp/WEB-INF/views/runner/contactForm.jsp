<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>	
<%@ taglib prefix="esapi" uri="http://www.owasp.org/index.php/Category:OWASP_Enterprise_Security_API" %>
<%@ page contentType="text/html; charset=UTF-8" session="false" %>
<!DOCTYPE html>
<html>
<head>
	<title>EUSurvey - <spring:message code="label.ContactForm" /></title>
	<%@ include file="../includes.jsp" %>
	
	<script type="text/javascript">
		function checkAndSubmit()
		{
			$(".validation-error").remove();
			var result = validateInput($("#supportForm"));
			
			 if ($(".g-recaptcha.unset").length > 0)	{
				$('#runner-captcha-error').show();
				return;
			 }
			
			if (result == false)
			{
				goToFirstValidationError($("#supportForm"));
			} else {
				$("#supportForm").submit();
			}			
		}
		
		function deleteUploadedFile(button)
		{
			var uid = $(button).closest(".uploadedfile").attr("data-id");
			var request = $.ajax({
				  url: contextpath + "/home/support/deletefile",
				  data: {uid : uid},
				  cache: false,
				  dataType: "json",
				  success: function(data)
				  {
					  if (!data.success)
					  {
						showError("the file could not be deleted from the server");			 
					  } else {
						  $(button).closest(".uploadedfile").remove();
						  
						  if ($(".uploadedfile").length < 2)
				    	  {
				    		$("#file-uploader-support").show();
				    	  }
					  }		
				  }
				});
		}
		
		$(function() {
			$("[data-toggle]").tooltip();
					
			var uploader = new qq.FileUploader({
			    element: $("#file-uploader-support")[0],
			    action: contextpath + '/home/support/uploadfile',
			    uploadButtonText: selectFileForUploadRunner,
			    params: {
			    	'_csrf': csrftoken
			    },
			    multiple: false,
			    cache: false,
			    sizeLimit: 1048576,
			    onComplete: function(id, fileName, responseJSON)
				{
			    	if (responseJSON.success)
			    	{
			    		$("#file-uploader-support-div").append("<div class='uploadedfile' data-id='" + responseJSON.uid + "'>" + responseJSON.name + "<a onclick='deleteUploadedFile(this)'><span class='glyphicon glyphicon-trash'></span></a><input type='hidden' name='uploadedfile' value='" + responseJSON.uid + "' /></div>")
				    	$("#file-uploader-support-div").show();
			    		
			    		if ($(".uploadedfile").length > 1)
			    		{
			    			$("#file-uploader-support").hide();
			    		}
			    	} else {
			    		showError(invalidFileError);
			    	}
				},
				showMessage: function(message){
					$("#file-uploader-support").append("<div class='validation-error'>" + message + "</div>");
				},
				onUpload: function(id, fileName, xhr){
					$("#file-uploader-support").find(".validation-error").remove();			
				}
			});
			
			$(".qq-upload-button").addClass("btn btn-default").removeClass("qq-upload-button");
			$(".qq-upload-list").hide();
			$(".qq-upload-drop-area").css("margin-left", "-1000px");
			
			<c:if test="${messagesent != null}">
				showSuccess('<spring:message code="support.messagesentowner" />')
			</c:if>
			
		});
	</script>
	
	<style type="text/css">
				
	</style>
</head>
<body style="text-align: center;">
	<div class="page-wrap">
		<%@ include file="../header.jsp" %>
	
		<div class='${responsive != null ? "responsivepage" : "page"}' style='padding-top: 40px;'>
	
			<div class="pageheader">
	 			<h1>${survey.title}</h1>
			</div>
			
			<spring:message code="label.ContactFormText" arguments='${contextpath}/home/documentation' /><br /><br />
			
			<form:form id="supportForm" action="${contextpath}/runner/contactform/${survey.shortname}" method="post" >

				<spring:message code="support.CannotLogin" var="CannotLogin" />
				<spring:message code="support.CannotComplete" var="CannotComplete" />
				<spring:message code="support.CannotUpload" var="CannotUpload" />
				<spring:message code="support.otherreason" var="OtherReason" />

				<label><span class="mandatory">*</span><spring:message code="support.ContactReason" /></label><br />
				<select class="form-control" style="max-width: 400px" name="contactreason">
					<option <c:if test='${contactFormReason == null || contactFormReason == CannotLogin}'>selected="selected"</c:if>><c:out value="${CannotLogin}" /></option>
					<option <c:if test='${contactFormReason == CannotComplete}'>selected="selected"</c:if>><c:out value="${CannotComplete}" /></option>
					<option <c:if test='${contactFormReason == CannotUpload}'>selected="selected"</c:if>><c:out value="${CannotUpload}" /></option>
					<option <c:if test='${contactFormReason == OtherReason}'>selected="selected"</c:if>><c:out value="${OtherReason}" /></option>
				</select><br /><br />
				
				<label><span class="mandatory">*</span><spring:message code="label.yourname" /></label><br />
				<input type="text" class="form-control required" name="name" value='${contactFormName != null ? contactFormName : USER != null ? USER.getFirstLastName() : "" }' /><br /><br />
				
				<label><span class="mandatory">*</span><spring:message code="label.youremail" /></label> <span class="helptext">(<spring:message code="support.forlatercontact" />)</span><br />
				<input type="text" class="form-control required email" id="supportemail" name="email" value='${contactFormMail != null ? contactFormMail : USER != null ? USER.getEmail() : "" }' /><br /><br />
				
				<label><span class="mandatory">*</span><spring:message code="support.subject" /></label><br />
				<input type="text" class="form-control required" name="subject" value="${contactFormSubject}" /><br /><br />
						
				<label><span class="mandatory">*</span><spring:message code="support.yourmessagetoowner" /></label>
				<textarea class="form-control required" rows="10" name="message">${contactFormMessage}</textarea><br /><br />
				
				<label><spring:message code="support.upload" /></label>
				<a data-toggle="tooltip" title="<spring:message code="support.maxfilesize" />"><span class="glyphicon glyphicon-question-sign"></span></a>
				<div id="file-uploader-support"></div>
				<div id="file-uploader-support-div"></div>
				
				<div class="captcha" style="margin-left: 0px; margin-bottom: 20px; margin-top: 40px;">			
					<c:if test="${!captchaBypass}">
					<%@ include file="../captcha.jsp" %>					
					</c:if>
		       	</div>
		       	<span id="error-captcha" class="validation-error hideme">
		       		<c:if test="${!captchaBypass}">
		       		<spring:message code="message.captchawrongnew" />
		       		</c:if>
		       	</span>
		       	
		       	<div style="text-align: center; margin: 50px;">
		       		<a class="btn btn-primary" onclick="checkAndSubmit()"><spring:message code="label.Submit" /></a>
		       	</div>
			
			</form:form>
			
		</div>
	</div>

	<c:choose>
		<c:when test="${responsive != null}">
			<%@ include file="../footerresponsive.jsp" %>
		</c:when>
		<c:otherwise>
			<%@ include file="../footer.jsp" %>		
		</c:otherwise>
	</c:choose>
	
	<%@ include file="../generic-messages.jsp" %>
	
	<c:if test="${message != null}">
		<script type="text/javascript">
			showInfo('${message}');
		</script>
	</c:if>

</body>
</html>
