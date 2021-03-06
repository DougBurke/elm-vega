port module HelloWorlds exposing (elmToJS)

import Platform
import VegaLite exposing (..)


myFirstVis : Spec
myFirstVis =
    toVegaLite
        [ title "Hello, World!"
        , dataFromColumns [] <| dataColumn "x" (Numbers [ 10, 20, 30 ]) []
        , mark Circle []
        , encoding <| position X [ PName "x", PmType Quantitative ] []
        ]


mySecondVis : Spec
mySecondVis =
    let
        enc =
            encoding
                << position X [ PName "Cylinders", PmType Ordinal ]
                << position Y [ PName "Miles_per_Gallon", PmType Quantitative ]
    in
    toVegaLite
        [ dataFromUrl "data/cars.json" []
        , mark Circle []
        , enc []
        ]


myOtherVis : Spec
myOtherVis =
    let
        enc =
            encoding
                << position X [ PName "Cylinders", PmType Ordinal ]
                << position Y [ PName "Miles_per_Gallon", PAggregate Average, PmType Quantitative ]
    in
    toVegaLite
        [ dataFromUrl "data/cars.json" []
        , mark Bar []
        , enc []
        ]



{- This list comprises tuples of the label for each embedded visualization (here vis1, vis2 etc.)
   and corresponding Vega-Lite specification.
   It assembles all the listed specs into a single JSON object.
-}


mySpecs : Spec
mySpecs =
    combineSpecs
        [ ( "vis1", myFirstVis )
        , ( "vis2", mySecondVis )
        , ( "vis3", myOtherVis )
        ]



{- The code below is boilerplate for creating a headless Elm module that opens
   an outgoing port to Javascript and sends the specs to it.
-}


main : Program Never Spec msg
main =
    Platform.program
        { init = ( mySpecs, elmToJS mySpecs )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


port elmToJS : Spec -> Cmd msg
