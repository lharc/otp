%%
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 2001-2018. All Rights Reserved.
%% 
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%% 
%% %CopyrightEnd%
%%

%%
-module(ei_print_SUITE).

-include_lib("common_test/include/ct.hrl").
-include("ei_print_SUITE_data/ei_print_test_cases.hrl").

-export([all/0, suite/0,
         init_per_testcase/2,
         atoms/1, tuples/1, lists/1, strings/1,
         maps/1, funs/1]).

-import(runner, [get_term/1]).

%% This test suite test the ei_print() function.
%% It uses the port program "ei_format_test".

suite() ->
    [{ct_hooks,[ts_install_cth]}].

all() ->
    [atoms, tuples, lists, strings, maps, funs].

init_per_testcase(Case, Config) ->
    runner:init_per_testcase(?MODULE, Case, Config).

%% Tests formatting various atoms.

atoms(Config) when is_list(Config) ->
    P = runner:start(Config, ?atoms),

    {term, "''"} = get_term(P),
    {term, "a"} = get_term(P),
    {term, "'A'"} = get_term(P),
    {term, "abc"} = get_term(P),
    {term, "'Abc'"} = get_term(P),
    {term, "ab@c"} = get_term(P),
    {term, "'The rain in Spain stays mainly in the plains'"} = get_term(P),

    {term, "a"} = get_term(P),
    {term, "ab"} = get_term(P),
    {term, "abc"} = get_term(P),
    {term, "ab@c"} = get_term(P),
    {term, "abcdefghijklmnopq"} = get_term(P),

    {term, "''"} = get_term(P),
    {term, "a"} = get_term(P),
    {term, "'A'"} = get_term(P),
    {term, "abc"} = get_term(P),
    {term, "'Abc'"} = get_term(P),
    {term, "ab@c"} = get_term(P),
    {term, "'The rain in Spain stays mainly in the plains'"} = get_term(P),

    {term, "a"} = get_term(P),
    {term, "ab"} = get_term(P),
    {term, "abc"} = get_term(P),
    {term, "ab@c"} = get_term(P),
    {term, "'   abcdefghijklmnopq   '"} = get_term(P),

    runner:recv_eot(P),
    ok.



%% Tests formatting various tuples

tuples(Config) when is_list(Config) ->
    P = runner:start(Config, ?tuples),

    {term, "{}"} = get_term(P),
    {term, "{a}"} = get_term(P),
    {term, "{a, b}"} = get_term(P),
    {term, "{a, b, c}"} = get_term(P),
    {term, "{1}"} = get_term(P),
    {term, "{[]}"} = get_term(P),
    {term, "{[], []}"} = get_term(P),
    {term, "{[], a, b, c}"} = get_term(P),
    {term, "{[], a, [], b, c}"} = get_term(P),
    {term, "{[], a, '', b, c}"} = get_term(P),

    runner:recv_eot(P),
    ok.



%% Tests formatting various lists

lists(Config) when is_list(Config) ->
    P = runner:start(Config, ?lists),

    {term, "[]"} = get_term(P),
    {term, "[a]"} = get_term(P),
    {term, "[a, b]"} = get_term(P),
    {term, "[a, b, c]"} = get_term(P),
    {term, "[1]"} = get_term(P),
    {term, "[[]]"} = get_term(P),
    {term, "[[], []]"} = get_term(P),
    {term, "[[], a, b, c]"} = get_term(P),
    {term, "[[], a, [], b, c]"} = get_term(P),
    {term, "[[], a, '', b, c]"} = get_term(P),
    {term, "[[x, 2], [y, 3], [z, 4]]"}= get_term(P),

    %% {term, "[{name, 'Madonna'}, {age, 21}, {data, [{addr, "E-street", 42}]}]"} = get_term(P),
    %% maybe regexp instead?
    {term, "[{pi, 3.141500}, {'cos(70)', 0.342020}]"} = get_term(P),
    {term, "[[pi, 3.141500], ['cos(70)', 0.342020]]"} = get_term(P),

    {term, "[-1]"} = get_term(P),

    runner:recv_eot(P),
    ok.

strings(Config) when is_list(Config) ->
    P = runner:start(Config, ?strings),

    {term, "\"\\n\""} = get_term(P),
    {term, "\"\\r\\n\""} = get_term(P),
    {term, "\"a\""} = get_term(P),
    {term, "\"A\""} = get_term(P),
    {term, "\"0\""} = get_term(P),
    {term, "\"9\""} = get_term(P),
    {term, "\"The rain in Spain stays mainly in the plains\""} = get_term(P),
    {term, "\"   abcdefghijklmnopq   \""} = get_term(P),

    runner:recv_eot(P),
    ok.

maps(Config) ->
    P = runner:start(Config, ?maps),

    {term, "#{}"} = get_term(P),
    {term, "#{key => value}"} = get_term(P),
    {term, "#{key => value, another_key => {ok, 42}}"} = get_term(P),

    runner:recv_eot(P),
    ok.

funs(Config) ->
    P = runner:start(Config, ?funs),

    {term, "#Fun{some_module.42.3735928559}"} = get_term(P),
    {term, "#Fun{some_module.37.195935983}"} = get_term(P),
    {term, "fun erlang:abs/1"} = get_term(P),

    runner:recv_eot(P),
    ok.
