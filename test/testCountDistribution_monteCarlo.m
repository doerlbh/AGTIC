
%% preparations
nPossibleOutcomes=numel(counts);
df=nPossibleOutcomes-1; 

nEvents=sum(counts);

if ~exist('probabilities','var')
    probabilities=ones(1,nPossibleOutcomes)/nPossibleOutcomes;
end

expectedCounts=probabilities*nEvents;



%% classical chi2 test
chi2=sum((counts-expectedCounts).^2./expectedCounts);
p_chi2=1-cdf('chi2',chi2,df);



%% monte-carlo test
% if chi2==inf
%     p=0; % the observed counts are impossible under H0
% else
    nSimulations=100000;
    chi2s_null=nan(nSimulations,1);

    cs_probs=cumsum(probabilities);

    for simulationI=1:nSimulations
        cylindricalDice=rand(nEvents,1);

        simulatedEventTypeIs=1+sum(repmat(cylindricalDice,[1 nPossibleOutcomes])>repmat(cs_probs,[nEvents 1]),2);

        simulatedCounts=countSelectedItems(simulatedEventTypeIs,1:nPossibleOutcomes);
        % OLD VERSION: faulty because it omits 0 counts for events with
        % indices higher than the maximal event index actually occurring
        %         table=tabulate(simulatedEventTypeIs);
        %         simulatedCounts=table(:,2)';

        chi2s_null(simulationI)=sum((simulatedCounts-expectedCounts).^2./expectedCounts);

        % if chi2 is nan, then one of the expected counts must have been zero,
        % in which case chi2 should be infinite
        %         if isnan(chi2s_null(simulationI))
        %             numerators=(simulatedCounts-expectedCounts).^2;
        %             denominators=expectedCounts;
        %             bothZero_LOG= (numerators==0) & (denominators==0);
        %             denominators(bothZero_LOG)=1; % if numerator is zero, ratio set to zero
        %             chi2s_null(simulationI)=sum(numerators./denominators); % inf can happen, nan cannot
        %         end
    end

    p=relRanksIn_excludeValue_upperBound(-chi2s_null,-chi2);
% end
