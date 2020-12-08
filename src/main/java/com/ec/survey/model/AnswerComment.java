package com.ec.survey.model;

import java.util.Date;

import javax.persistence.*;

import org.springframework.format.annotation.DateTimeFormat;

import com.ec.survey.tools.ConversionTools;

@Entity
@Table(name = "ANSWERS_COMMENTS", indexes = {@Index(name = "ANSWERCOMMENT_IDX", columnList = "ANSWER_SET_ID, QUESTION_UID")})
public class AnswerComment implements java.io.Serializable {
	private static final long serialVersionUID = 1L;

	private Integer id;
	private String uniqueCode; // the code of the answerSet of the creator of the comment
	private Integer answerSetId; //the answerSet of the participant that created the answer
	private String questionUid;
	private String text;
	private AnswerComment parent;
	private Date date;

	public AnswerComment() {}

	public AnswerComment(int answerSetId, String questionUid) {
		this.answerSetId = answerSetId;
		this.questionUid = questionUid;
	}

	@Id
	@Column(name = "ANSWER_EXPLANATION_ID")
	@GeneratedValue
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name="ANSWER_SET_ID")
	public Integer getAnswerSetId() {
		return answerSetId;
	}
	public void setAnswerSetId(Integer answerSetId) {
		this.answerSetId = answerSetId;
	}

	@Column(name="QUESTION_UID")
	public String getQuestionUid() {
		return questionUid;
	}
	public void setQuestionUid(String questionUid) {
		this.questionUid = questionUid;
	}
	
	@Column(name="ANSWER_SET_CODE")
	public String getUniqueCode() {
		return uniqueCode;
	}
	public void setUniqueCode(String uniqueCode) {
		this.uniqueCode = uniqueCode;
	}

	@Lob
	@Column(name = "TEXT", nullable = false)
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}

	@ManyToOne  
	@JoinColumn(name="PARENT")
	public AnswerComment getParent() {
		return parent;
	}
	public void setParent(AnswerComment parent) {
		this.parent = parent;
	}
	
	@Column(name = "COMMENT_DATE")
	@DateTimeFormat(pattern = ConversionTools.DateTimeFormat)
	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
}
