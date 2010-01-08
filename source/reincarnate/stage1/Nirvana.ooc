import structs/ArrayList

import reincarnate/[App, Nirvana, Usefile, Version]
import reincarnate/stage1/Stage1

NirvanaS1: class extends Stage1 {
    init: func (.app) {
        this(app)
    }

    getUsefile: func (location, ver, variant: String) -> Usefile {
        if(ver == null) {
            ver = "latest"
        }
        usefile := Usefile new(app nirvana getUsefile(location, ver, variant))
        usefile put("_Slug", location)
        return usefile
    }
}
