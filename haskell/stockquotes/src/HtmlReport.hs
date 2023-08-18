{-# LANGUAGE OverloadedStrings #-}

module HtmlReport where

import           Colonnade                     (Colonnade, Headed, headed)
import           Control.Monad                 (unless)
import           Data.ByteString.Lazy          (ByteString)
import           Data.Foldable                 (traverse_)
import           Fmt                           (Buildable, pretty)
import           Text.Blaze.Colonnade          (encodeHtmlTable)
import           Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import           Text.Blaze.Html5              as H (Html, ToValue (toValue),
                                                     body, docTypeHtml, h1,
                                                     head, i, img, string,
                                                     style, text, title, (!))
import           Text.Blaze.Html5.Attributes   (src)

import           QuoteData                     (QuoteData (close, day, high, low, open, volume))
import           StatReport                    (StatEntry (daysBetweenMinMax, maxVal, meanVal, minVal, qfield),
                                                showPrice)

viaFmt :: Buildable a => a -> Html
viaFmt = text . pretty

colStats :: Colonnade Headed StatEntry Html
colStats =
  mconcat
    [ headed "Quote Field" (i . string . show . qfield)
    , headed "Mean" (viaFmt . meanVal)
    , headed "Min" (viaFmt . minVal)
    , headed "Max" (viaFmt . maxVal)
    , headed "Days between Min/Max" (viaFmt . daysBetweenMinMax)
    ]

colData :: Colonnade Headed QuoteData Html
colData =
  mconcat
    [ headed "Day" (viaFmt . day)
    , headed "Open" (viaFmt . showPrice . open)
    , headed "Close" (viaFmt . showPrice . close)
    , headed "High" (viaFmt . showPrice . high)
    , headed "Low" (viaFmt . showPrice . low)
    , headed "Volume" (viaFmt . volume)
    ]

htmlReport ::
     (Functor t, Foldable t)
  => String
  -> t QuoteData
  -> [StatEntry]
  -> [FilePath]
  -> ByteString
htmlReport docTitle quotes statEntries images =
  renderHtml $
  docTypeHtml $ do
    H.head $ do
      title $ string docTitle
      style tableStyle
    body $ do
      unless (null images) $ do
        h1 "Charts"
        traverse_ ((img !) . src . toValue) images
      h1 "Statistics Report"
      encodeHtmlTable mempty colStats statEntries
      h1 "Stock Quotes Data"
      encodeHtmlTable mempty colData quotes
  where
    tableStyle =
      "table {border-collapse: collapse}" <>
      "td, th {border: 1px solid black; padding: 5px}"
