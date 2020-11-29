%%%-------------------------------------------------------------------
%% @doc epmdlessless public API
%% @end
%%%-------------------------------------------------------------------

-module(epmdlessless_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    epmdlessless_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
