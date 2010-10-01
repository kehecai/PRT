function d = prtUtilBhattacharyyaDistance(varargin)
%d = prtUtilBhattacharyyaDistance(X1,X2)
%d = prtUtilBhattacharyyaDistance(DataSet1)
%d = prtUtilBhattacharyyaDistance(DataSet1,DataSet2)

if nargin == 1
    DataSet1 = varargin{1};
    if ~isa(DataSet1,'prtDataSetBase')
        error('prt:prtUtilBhattacharyyaDistance:invalidInputs','prtUtilBhattacharyyaDistance with one input argument requires the input to be a prtDataSet; input was a %s',class(x1));
    elseif ~DataSet1.isLabeled
        error('prt:prtUtilBhattacharyyaDistance:invalidInputs','prtUtilBhattacharyyaDistance with one input argument requires the data set to be labeled');
    elseif ~DataSet1.isZeroOne
        error('prt:prtUtilBhattacharyyaDistance:invalidInputs','prtUtilBhattacharyyaDistance with one input argument requires the data set to be labeled with class numbers 0 and 1');
    end
    x0 = DataSet1.getObservationsByClass(0);
    x1 = DataSet1.getObservationsByClass(1);
elseif nargin == 2
    if isnumeric(varargin{1}) && isnumeric(varargin{2})
        x0 = varargin{1};
        x1 = varargin{2};
    elseif isa(varargin{1},'prtDataSetBase') && isa(varargin{2},'prtDataSetBase')
        x0 = varargin{1}.getObservations;
        x1 = varargin{2}.getObservations;
    else
        error('prt:prtUtilBhattacharyyaDistance:invalidInputs','prtUtilBhattacharyyaDistance with two inputs requires both inputs to be numeric or prtDataSetBase, but inputs were: %s and %s',class(varargin{1}),class(varargin{2}));
    end
end

if any(isnan(x0(:))) || any(isnan(x1(:)))
    m0 = nanmean(x0);
    m1 = nanmean(x1);
    if size(x0,2) == 1
        c0 = nanvar(x0);
        c1 = nanvar(x1);
    else
        c0 = nancov(x0);
        c1 = nancov(x1);
    end
else
    m0 = mean(x0);
    m1 = mean(x1);
    if size(x0,2) == 1
        c0 = nanvar(x0);
        c1 = nanvar(x1);
    else
        c0 = cov(x0);
        c1 = cov(x1);
    end
end

%warning off
logTerm = log( det((c1+c0)/2)./sqrt(det(c1)*det(c0)) );
%warning on;
if isnan(logTerm) || logTerm < eps;
    logTerm = eps;
end

d = 1/8*(m1-m0)*((c1+c0)/2)^-1*(m1-m0)' + 1/2 * logTerm;