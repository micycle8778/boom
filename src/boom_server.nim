# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import asynchttpserver, asyncdispatch, nativesockets, tables, strutils, osproc
import uri, os

when isMainModule:
  func parseQuery(query: string): Table[string, seq[string]] =
    for s in query.split('&'):
      if s == "": continue
      let arr = s.split('=')
      if not (arr[0] in result):
        result[arr[0]] = @[]
      result[arr[0]].add(arr[1])

  proc requestHandler(req: Request) {.async.} =
    if req.url.path != "/":
      await req.respond(Http400, "Bad path.")
    else:
      let query = parseQuery(req.url.query)
      if "q" in query:
        if query["q"].len != 1:
          await req.respond(Http400, "Multiple search queries found.")
        let res = execCmdEx("boom " & decodeUrl(query["q"][0], false))
        case res.exitcode:
          of 0:
            if res.output == "":
              await req.respond(Http400, "Empty search query.")
              echo "Empty search query."
            else:
              let headers = newHttpHeaders({"Location": res.output})
              await req.respond(Http302, "", headers)
              stdout.write "Sent user to " & res.output
          of 1:
            await req.respond(Http500, res.output)
            echo "Config file error. (" & res.output & ")"
          of 2:
            await req.respond(Http400, res.output)
            echo "Bang not found error. (" & res.output & ")"
          else:
            await req.respond(Http500, "Unknown error occured.")
            echo "Unknown error."
            echo res
      else:
        await req.respond(Http400, "Search query not found.")

  let host = getEnv("BOOM_SERVER_HOST", "localhost")
  
  var port: uint
  try:
    port = parseUInt(getEnv("BOOM_SERVER_PORT", "5432"))
  except ValueError:
    quit("BOOM_SERVER_PORT is not a number!")
  if port > Port.high.uint:
    quit("BOOM_SERVER_PORT is too high!")


  let server = newAsyncHttpServer()
  echo "Server up"
  waitFor server.serve(Port(port), requestHandler, host)

