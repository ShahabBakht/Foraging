function Output = preprocessForaging()
DataFolder = 'D:\Data\Psychophysics\Foraging\';
TestName = '17031301';
DATA = load([DataFolder,TestName,'.mat']);
X = DATA.FORAGEresult.eyeX;
Y = DATA.FORAGEresult.eyeY;
FixationX = DATA.FORAGEresult.FixationX;
FixationY = DATA.FORAGEresult.FixationY;
Jitters = DATA.FORAGEresult.Jitters;

targetLocation = DATA.FORAGEresult.thisTargetLocation;
fixationLocation = DATA.FORAGEresult.thisFixationLocation;
trialsOrder = DATA.FORAGEresult.trialsOrder;
numBGImages = DATA.FORAGEresult.StimulusObject.numBGImages;
numTrials = DATA.FORAGEresult.StimulusObject.numTrials;
allTrials = repmat(1:numBGImages,1,numTrials);
perbgtrialcount = zeros(1,numBGImages);

% this loop sorts the eye, target and fixation positions to for different
% bg images
for trcount = 1 : (numTrials * numBGImages)
    thisTrialBGImage = allTrials(trialsOrder(trcount));
    
    for bgcount = 1:numBGImages
        if thisTrialBGImage == bgcount
            perbgtrialcount(bgcount) = perbgtrialcount(bgcount) + 1;
            Xsorted{bgcount,perbgtrialcount(bgcount)} = X{trcount};
            Ysorted{bgcount,perbgtrialcount(bgcount)} = Y{trcount};
            fixXsorted{bgcount,perbgtrialcount(bgcount)} = FixationX{trcount};
            fixYsorted{bgcount,perbgtrialcount(bgcount)} = FixationY{trcount};
            sortedJitters(bgcount,perbgtrialcount(bgcount),:) = Jitters(:,trcount);
            targetLocationsorted(bgcount,perbgtrialcount(bgcount),:) = targetLocation(:,trcount);
            fixationLocationsorted(bgcount,perbgtrialcount(bgcount),:) = fixationLocation(:,trcount);
        end

    end
end

Output.Xsorted = Xsorted;
Output.Ysorted = Ysorted;
Output.fixXsorted = fixXsorted;
Output.fixYsorted = fixYsorted;
Output.targetLocationsorted = targetLocationsorted;
Output.fixationLocationsorted = fixationLocationsorted;
Output.Jitters = sortedJitters;

% learning curves
Latency = cellfun(@(x)length(x),Xsorted);
Output.Latency = Latency;




end
