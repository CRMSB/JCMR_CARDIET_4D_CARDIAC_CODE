function A = read_bru_experiment(PathName)
%
% read bruker experiment and saved processed data
%

if nargin<1 %choose the directory
    PathName=uigetdir('*.*','Open rawdata bruker directory');
    cd(PathName);
    if isequal(PathName,0)
        error('directory path is not well defined');
    end
end

%% read various parameter files
jdxfiles = {'proc' 'procs' 'proc2' 'proc2s'...
            'acqu' 'acqus' 'acqu2' 'acqu2s'...
            'acqp' 'method' 'scon2' 'visu_pars'};

for fn=jdxfiles
    filename = [PathName '/' fn{1}];
    if exist(filename, 'file')==2
        A.(fn{1}) = mexldr(filename);
        %disp(sprintf('loaded %s', filename));
    end
end

%% read the processed data files/directoies
pdatapath = [PathName '/pdata/'];
pdatadirs = dir(pdatapath);

if length(pdatadirs)
    A.pdata = containers.Map('KeyType','int32','ValueType','any');
end
for jj=1:length(pdatadirs)
    % 1...N
    pdatanum = str2num(pdatadirs(jj).name);
    procpath = [pdatapath pdatadirs(jj).name];
    if ~isdir(procpath) || 0 == length(pdatanum)
        continue;
    end
    try
        A.pdata(pdatanum) = read_bru_experiment(procpath);
    catch err
        disp(sprintf('couldnt read %s\n', procpath));
        err
        err.stack(:).file
        err.stack(:).line
        break;
    end
end

%% read the raw data
if exist([PathName '/fid'])
    fpre = fopen([PathName '/fid'],'r');
    A.fid = fread(fpre,'int32','l');
    A.fid = A.fid(1:2:end) - 1i * A.fid(2:2:end);
    fclose(fpre);
end

if exist([PathName '/title'])
    fp = fopen([PathName '/title'],'r');
    A.title = fread(fp, 'int8=>char')';
    fclose(fp);
end

if exist([PathName '/ser'])
    fpre = fopen([PathName '/ser'],'r');
    A.fid = fread(fpre,'int32','l');
    A.fid = A.fid(1:2:end) - 1i * A.fid(2:2:end);
    if isfield(A.acqus, 'TD')
        A.fid = reshape(A.fid, A.acqus.TD/2, []);
    end
    fclose(fpre);
end
    
if exist([PathName '/vdlist'])
    A.vdlist = read_bru_delaylist([PathName '/vdlist']);
end

if exist([PathName '/1r'])
    fpre = fopen([PathName '/1r'],'r');
    fpim = fopen([PathName '/1i'],'r');
    A.spec = fread(fpre,'int32') + 1i * fread(fpim,'int32');
    % scale the spectrum according to NC_proc (going from 32-bit int to 64-bit double anyway)
    A.spec = A.spec .* (2^A.procs.NC_proc);
    fclose(fpre);
    fclose(fpim);
end

for FILE = {'acqus' 'procs'}
    if ~isfield(A,FILE{1}) || ~isfield(A,'DATE')
        continue
    end
    %% Add acq-date
    % Converts time given in UTC (base 1970, seconds) as matlab serial time
    % (base 0000, days)
    TZ = str2double(regexp(A.(FILE{1}).Stamp,'UT(.\d+)h','tokens','once'));
    if isempty(TZ); TZ = 2; end;	% Assume UT+2h if not in stamp-field
    A.Info.AcqSerialDate = A.(FILE{1}).DATE/(60*60*24)+datenum([1970 01 01])+TZ/24;
    A.Info.AcqDateTime = datestr(A.Info.AcqSerialDate);
    A.Info.AcqDate = datestr(A.Info.AcqSerialDate,'yyyy-mm-dd');
    % Convert serial date to text to keep format
    A.Info.AcqSerialDate = sprintf('%.12f',A.Info.AcqSerialDate);

    %% Add plotlabel from A.(FILE{1}).Stamp-info
    q = regexp(A.(FILE{1}).Stamp,'data[/\\].+[/\\]nmr[/\\](.+)[/\\](\d+)[/\\]acqus','tokens');
    if isempty(q)	% New, more relaxed, data path
	q = regexp(A.(FILE{1}).Stamp,'#.+[/\\](.+)[/\\](\d+)[/\\]acqus','tokens');
    end
    if isempty(q)
	A.Info.PlotLabel = ['[',A.Info.FilePath,']'];
    else
	A.Info.PlotLabel = ['[',q{1}{1},':',q{1}{2},']'];
    end
end
