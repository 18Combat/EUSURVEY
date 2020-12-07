package com.ec.survey.model.survey;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.owasp.esapi.errors.ValidationException;

import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import com.ec.survey.tools.Tools;
import java.util.Objects;

/**
 * Represents a single choice question in a survey
 */
@Entity
@DiscriminatorValue("SINGLECHOICE")
@Cacheable
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class SingleChoiceQuestion extends ChoiceQuestion {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public SingleChoiceQuestion() {
	}

	public SingleChoiceQuestion(String title, String shortname, String uid) {
		super(title, shortname, uid);
	}

	private boolean useRadioButtons;
	private int numColumns = 1;

	@Column(name = "RADIO")
	public boolean getUseRadioButtons() {
		return useRadioButtons;
	}

	public void setUseRadioButtons(boolean useRadioButtons) {
		this.useRadioButtons = useRadioButtons;
	}

	@Column(name = "NUMCOLUMNS")
	public int getNumColumns() {
		return numColumns;
	}

	public void setNumColumns(int numColumns) {
		this.numColumns = numColumns;
	}
	
	public SingleChoiceQuestion copy(String fileDir) throws ValidationException
	{
		SingleChoiceQuestion questionCopy = new SingleChoiceQuestion();
		baseCopy(questionCopy);
		questionCopy.numColumns = numColumns;
		questionCopy.useRadioButtons = useRadioButtons;
		questionCopy.setOrder(getOrder());
		
		for (PossibleAnswer possibleAnswer : getPossibleAnswers()) {
			PossibleAnswer answerCopy = possibleAnswer.copy(fileDir);
			questionCopy.getPossibleAnswers().add(answerCopy);
		}
		
		return questionCopy;
	}

	@Override
	public boolean differsFrom(Element element) {
		if (basicDiffersFrom(element))
			return true;

		if (!(element instanceof SingleChoiceQuestion))
			return true;

		SingleChoiceQuestion single = (SingleChoiceQuestion) element;

		if (useRadioButtons != single.useRadioButtons)
			return true;
		if (numColumns != single.numColumns)
			return true;
		if (getPossibleAnswers().size() != single.getPossibleAnswers().size())
			return true;

		if (!Objects.equals(getOrder(), single.getOrder()))
			return true;

		for (int i = 0; i < getPossibleAnswers().size(); i++) {
			if (!getPossibleAnswers().get(i).getTitle().equals(single.getPossibleAnswers().get(i).getTitle()))
				return true;
			if (!getPossibleAnswers().get(i).getDependentElementsUIDString()
					.equals(single.getPossibleAnswers().get(i).getDependentElementsUIDString()))
				return true;
			if (!Tools.isEqual(getPossibleAnswers().get(i).getShortname(),
					single.getPossibleAnswers().get(i).getShortname()))
				return true;

			if (getPossibleAnswers().get(i).getScoring() != null && getPossibleAnswers().get(i).getScoring()
					.differsFrom(single.getPossibleAnswers().get(i).getScoring())) {
				return true;
			}
		}

		return false;
	}

}
