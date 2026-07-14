import argparse
import os
from functools import partial
from http.server import SimpleHTTPRequestHandler, test


class HtmlFallbackHandler(SimpleHTTPRequestHandler):
    def translate_path(self, path):
        fs = super().translate_path(path)
        # if the exact path is missing but <path>.html exists, serve that
        if not os.path.exists(fs) and os.path.exists(fs + '.html'):
            return fs + '.html'
        return fs


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', '--bind', metavar='ADDRESS',
                        help='bind to this address (default: all interfaces)')
    parser.add_argument('-d', '--directory', default=os.getcwd(),
                        help='serve this directory (default: current directory)')
    parser.add_argument('-p', '--protocol', metavar='VERSION', default='HTTP/1.0',
                        help='conform to this HTTP version (default: HTTP/1.0)')
    parser.add_argument('port', default=8000, type=int, nargs='?',
                        help='bind to this port (default: 8000)')
    args = parser.parse_args()

    handler_class = partial(HtmlFallbackHandler, directory=args.directory)
    test(HandlerClass=handler_class, port=args.port, bind=args.bind,
         protocol=args.protocol)
