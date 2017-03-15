Object.prototype.values = function(){var o=this;var r=[];for(var k in o) if(o.hasOwnProperty(k)){r.push(o[k])}return r};

//JSON配列を指定のキーで集計する
Array.prototype.groupBy = function(keys,sumKeys) {
    var hash = this.reduce(function(res,data) {
        // 集計キーを作成
        var key = keys.reduce(function(s,k) {
            s += data[k];
            return s;
        },'');
        // 初めての集計キー
        if(!(key in res)) {
            // 集計キーをオブジェクトに設定
            var keyList = keys.reduce(function(h,k) {
                h[k] = data[k];
                return h;
            },{});
            // 集計項目の初期値を設定
            res[key] = sumKeys.reduce(function(h,k) {
                h[k] = 0;
                return h;
            }, keyList);
        }
        // データを集計（加算）
        sumKeys.forEach(function(k){
            res[key][k] += data[k];
        });

        return res;
    },{});

    return hash.values();
};