
%  test for current time obtaining.
% c = clock;
% folder_name = [num2str(c(1)), ... % year
%                '_', ...
%                num2str(c(2)), ... % month
%                '_', ...
%                num2str(c(3)), ... % day
%                '_', ...
%                num2str(c(4)), ... % hour
%                '_', ...
%                num2str(c(5)), ... % minute
%                '_', ...
%                num2str(fix(c(6)))]; % second

% test for self-define input parameters of callback functions
% function testtest()
%     clear,close all,clc
%     t = timer('Period', 2, ...
%               'ExecutionMode', 'fixedSpacing', ...
%               'TasksToExecute', 2, ...
%               'TimerFcn', {@PrintMessage, 'displaying...'});
%     start(t)
% 
% function PrintMessage(obj, event, message)
%     obj
%     event
%     disp(message);

% test for switch-case with 'string' case
keyword = 'abc';

switch keyword
    case 'a'
        disp('a')
    case 'b'
        disp('b')
    case 'abc'
        disp('abc')
end