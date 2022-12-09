module Day7Shared exposing (File(..), buildFileSystem, parseCommands)

import Dict exposing (Dict)
import Parser as P exposing ((|.), (|=), DeadEnd, Parser, Step(..))


type File
    = File String Int
    | Dir String


type CdParam
    = CdRoot
    | CdUp
    | CdTo String


type Command
    = Cd CdParam
    | Ls (List File)


cmdsParser : Parser (List Command)
cmdsParser =
    P.loop []
        (\cmds ->
            P.oneOf
                [ P.succeed (\cmd -> cmd :: cmds)
                    |= cmdParser
                    |> P.map Loop
                , P.succeed cmds
                    |. P.chompIf (always True)
                    |> P.map Loop
                , P.succeed (List.reverse cmds)
                    |. P.end
                    |> P.map Done
                ]
        )


cmdParser : Parser Command
cmdParser =
    P.oneOf
        [ cdParser
        , lsParser
        ]


lsParser : Parser Command
lsParser =
    P.succeed Ls
        |. P.token "$ ls"
        |. P.token "\n"
        |= fileListParser


fileListParser : Parser (List File)
fileListParser =
    P.loop []
        (\files ->
            P.oneOf
                [ P.succeed (\file -> file :: files)
                    |= fileParser
                    |> P.map Loop
                , P.succeed (List.reverse files)
                    |> P.map Done
                ]
        )


fileParser : Parser File
fileParser =
    P.oneOf
        [ P.succeed Dir
            |. P.token "dir "
            |= (P.getChompedString <| P.chompWhile Char.isAlpha)
            |. P.spaces
        , P.succeed (\size name -> File name size)
            |= P.int
            |. P.token " "
            |= (P.getChompedString <| P.chompWhile (\ch -> Char.isAlpha ch || ch == '.'))
            |. P.spaces
        ]


cdParser : Parser Command
cdParser =
    P.succeed Cd
        |. P.token "$ cd "
        |= cdParamParser


cdParamParser : Parser CdParam
cdParamParser =
    P.oneOf
        [ P.succeed (always CdRoot)
            |= P.symbol "/"
        , P.succeed (always CdUp)
            |= P.token ".."
        , P.succeed CdTo
            |= (P.chompWhile Char.isAlpha |> P.getChompedString)
        ]


parseCommands : String -> Result (List DeadEnd) (List Command)
parseCommands input =
    P.run cmdsParser input


buildFileSystem : List Command -> Dict String (List File)
buildFileSystem cmds =
    let
        buildFileSystem_ : Command -> ( Dict String (List File), List String ) -> ( Dict String (List File), List String )
        buildFileSystem_ cmd ( dict, path ) =
            case cmd of
                Cd CdRoot ->
                    ( dict, [ "root" ] )

                Cd CdUp ->
                    ( dict, List.take (List.length path - 1) path )

                Cd (CdTo dirName) ->
                    ( dict, path ++ [ dirName ] )

                Ls files ->
                    let
                        fullpath =
                            String.join "/" path
                    in
                    ( Dict.insert fullpath files dict, path )
    in
    cmds
        |> List.foldl buildFileSystem_ ( Dict.empty, [] )
        |> Tuple.first
