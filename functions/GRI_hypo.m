%%%%%%%%%%%%%%%%%
%GRI hypo component
%https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10563532/pdf/10.1177_19322968221085273.pdf
function [GRI_hypo_out] = GRI_hypo(CGM)

VLow = (size(CGM(CGM<54),1)/size(CGM,1))*100;
Low = (size(CGM(CGM<70 & CGM>=54),1)/size(CGM,1))*100;


GRI_hypo_out = VLow + (0.8 * Low);

end
