module Route.Routing ( route ) where

import Happstack.Server          ( ok, Method(GET, POST, DELETE, PUT), nullDir
                                 , Request(rqMethod), askRq , BodyPolicy(..)
                                 , decodeBody, defaultBodyPolicy, look )

import Data.Domain.Types         ( UserId, EntryId, TaskId )
import Route.PageEnum            ( SiteMap(..) )

import Controller.AcidHelper     ( CtrlV )
import qualified Controller.UserController      as UserController
import qualified Controller.HomeController      as HomeController
import qualified Controller.CalendarController  as CalendarController
import qualified Controller.TaskController      as TaskController



myPolicy :: BodyPolicy
myPolicy = defaultBodyPolicy "/tmp/" 0 1000 1000

-- | the route mapping function
route :: SiteMap -> CtrlV
route url =
  do  decodeBody myPolicy
      case url of
        Home                 -> HomeController.homePage
        Userdetail           -> routeDetailUser
        User i               -> routeUser i
        CalendarEntry i      -> routeCalendarEntry i
        Task i               -> routeTask i
        TaskWithCalendar e u -> routeTaskWithCalendar e u
        TaskWithUser t u     -> routeTaskWithUser t u

getHttpMethod = do
  nullDir
  g <- greet
  ok g
    where
  greet =
    rqMethod <$> askRq

routeUser :: UserId -> CtrlV
routeUser userId = do
  m <- getHttpMethod
  case m of
    GET  ->
      UserController.userPage userId
    DELETE ->
      UserController.deleteUser userId
    POST -> do
      description <- look "description"
      CalendarController.createCalendarEntry userId description
    PUT -> do
      name <- look "name"
      UserController.updateUser userId name

routeDetailUser :: CtrlV
routeDetailUser = do
  m <- getHttpMethod
  case m of
  -- curl -X POST -d "name=FooBar" http://localhost:8000/userdetail
    POST -> do
      name <- look "name"
      UserController.createUser name

routeTask :: TaskId -> CtrlV
routeTask taskId = do
  m <- getHttpMethod
  case m of
    GET  ->
      TaskController.taskPage taskId
    PUT -> do
      description <- look "description"
      TaskController.updateTask taskId description

routeTaskWithCalendar :: EntryId ->  TaskId -> CtrlV
routeTaskWithCalendar entryId taskId = do
  m <- getHttpMethod
  case m of
    DELETE ->
      TaskController.deleteTask entryId taskId

routeTaskWithUser :: TaskId -> UserId -> CtrlV
routeTaskWithUser taskId userId = do
  m <- getHttpMethod
  case m of
    DELETE ->
      TaskController.removeUserFromTask taskId userId
    PUT ->
      TaskController.addUserToTask taskId userId

routeCalendarEntry :: EntryId -> CtrlV
routeCalendarEntry entryId = do
  m <- getHttpMethod
  case m of
    DELETE ->
      CalendarController.deleteCalendarEntry entryId
    GET ->
      CalendarController.entryPage entryId
    POST -> do
      description <- look "description"
      TaskController.createTask entryId description
    PUT -> do
      description <- look "description"
      CalendarController.updateCalendarEntry entryId description