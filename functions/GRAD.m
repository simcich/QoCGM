%%%%%%%%%%%%%%%
% Glycaemic Risk Assessment Diabetes Equation (GRADE)
%  https://doi.org/10.1111/j.1464-5491.2007.02119.x
function [GRADE GRADE_hypo GRADE_eu GRADE_hyper] = GRAD(Glucose)

GRADEs =425 * ((log10(log10(Glucose/18)) + 0.16).^2);
GRADE = mean(GRADEs);

%calculating GRADE hypoglycaemia percent
hypos = (Glucose < 90);
HypoPercent = 100*sum(GRADEs(hypos))/sum(GRADEs);
GRADE_hypo = HypoPercent;


%calculating GRADE euglycaemia percent
eus =  (Glucose>=90 & Glucose<=140);
EuPercent = 100*sum(GRADEs(eus))/sum(GRADEs);
GRADE_eu = EuPercent;

%calculating GRADE hyperglycaemia percent
hypers = (Glucose > 140);
HyperPercent = 100*sum(GRADEs(hypers))/sum(GRADEs);
GRADE_hyper = HyperPercent;


end