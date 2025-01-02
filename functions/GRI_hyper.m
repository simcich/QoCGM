%GRI hyper component
function [GRI_hyper_out] = GRI_hyper(CGM)

VHigh = (size(CGM(CGM>250),1)/size(CGM,1))*100;
High = (size(CGM(CGM>180 & CGM<=250),1)/size(CGM,1))*100;


GRI_hyper_out = VHigh + (0.5 * High);

end