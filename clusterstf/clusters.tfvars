/**************************/

lke_cluster = [
    {
        label : "lke-demo-simple"
        k8s_version : "1.26"
        region : "us-southeast"
        pools = [
            {
                type : "g6-standard-2"
                count : 2
            }
        ]
    }
]