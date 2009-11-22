use yajl

import yajl/Yajl
import structs/ArrayList

import reincarnate/Net

APIException: class extends Exception {
    init: func ~withMsg (.msg) {
        super(msg)
    }    
}

Nirvana: class {
    urlTemplate: String

    init: func (=urlTemplate) {}

    _getUrl: func (path: String) -> String {
        urlTemplate format(path)
    }

    _downloadUrl: func (path: String) -> String {
        Net downloadString(_getUrl(path))
    }

    _interpreteUrl: func (path: String) -> ValueMap {
        content := _downloadUrl(path)
        parser := SimpleParser new()
        parser parseAll(content)
        value := parser getValue(ValueMap) as ValueMap /* TODO: what if we don't get a ValueMap? */
        // did we get an error?
        s := value get("__result", String)
        if(s equals("error")) {
            APIException new(This, value get("__text", String)) throw()
        }
        value remove("__result")
        value
    }

    getCategories: func -> ArrayList<String> {
        map := _interpreteUrl("/categories/")
        return map keys
    }

    getPackages: func (category: String) -> ArrayList<String> {
        map := _interpreteUrl("/category/%s/" format(category))
        return map keys
    }
}
