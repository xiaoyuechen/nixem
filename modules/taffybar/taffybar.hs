{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.IO.Class
import Data.Default
import qualified GI.Gtk as Gtk
import System.Environment
import System.Process
import System.Taffybar
import System.Taffybar.DBus
import System.Taffybar.Example
import System.Taffybar.SimpleConfig
import System.Taffybar.Util
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.PollingGraph

main :: IO ()
main = do
  configHome <- getEnv "XDG_CONFIG_HOME"
  dyreTaffybar
    . withLogServer
    . withToggleServer
    . toTaffyConfig
    $ mySimpleConfig
      { cssPaths = [configHome ++ "/taffybar/taffybar.css"]
      }

buildBoxFromWidgets widgets =
  do
    box <-
      foldr
        ( \child parent -> do
            childBox <- child
            parentBox <- parent
            Gtk.containerAdd parentBox childBox
            return parentBox
        )
        (Gtk.boxNew Gtk.OrientationHorizontal 0)
        widgets
    Gtk.widgetShowAll box
    Gtk.toWidget box

mySimpleConfig :: SimpleTaffyConfig
mySimpleConfig =
  let workspaces =
        workspacesNew
          def
            { minIcons = 1
            , widgetGap = 0
            , showWorkspaceFn = hideEmpty
            }
      sysinfo =
        let cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
            mem = pollingGraphNew memCfg 1 memCallback
            net = networkGraphNew netCfg Nothing
            battery = textBatteryNew "$percentage$%"
         in buildBoxFromWidgets (map (>>= buildPadBox) [battery, net, mem, cpu]) >>= buildPadBox
      clock =
        textClockNewWith
          def
            { clockTimeZone = Nothing
            , clockTimeLocale = Nothing
            , clockFormatString = "<b>%a %-d %b</b>  %R"
            }
      windows = windowsNew def
      tray = sniTrayNew
      weather =
        weatherNew
          (defaultWeatherConfig "ESCM")
            { weatherTemplate = "$stationPlace$ $tempC$ °C"
            }
          10
   in def
        { monitorsAction = usePrimaryMonitor
        , startWidgets = [workspaces, windows >>= buildPadBox]
        , centerWidgets = [clock]
        , endWidgets =
            [ buildBoxFromWidgets [tray] >>= buildContentsBox
            , sysinfo
            , weather >>= buildPadBox
            ]
        , barPosition = Top
        , barPadding = 0
        , barHeight = ScreenRatio $ 4 / 100
        , widgetSpacing = 16
        }
