%%%%%%%%%%%%%%%%%
%LBGI / HBGI
%Kovatchev BP, Cox DJ, Gonder-Frederick LA, Young-Hyman D, Schlundt D, Clarke WL: Assessment of risk for severe hypoglycemia among adults with IDDM: validation of the low blood glucose index. Diabetes Care 21:1870–1875, 1998
%Kovatchev BP, Cox DJ, Gonder-Frederick LA, Clarke WL: Methods for quantifying self-monitoring blood glucose profiles exemplified by an examination of blood glucose patterns in patients with type 1 and type 2 diabetes. Diabetes Technol Ther 4:295–303, 2002
function [LBGI HBGI] = calculateBGI(CGM)

f_Glucose = 1.509 * ((log(CGM).^1.084) - 5.381); %mg/dL


r_Glucose = 10 * (f_Glucose.^2);

LBGI = mean(r_Glucose.*(f_Glucose < 0));
HBGI = mean(r_Glucose.*(f_Glucose > 0));


end

