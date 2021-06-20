import java.util.*;

public class Puzzle{
    static int mode; // 0 : dijkstra, 1 : unmatched, 2 : distance 
    static final int BW = 4; //1個のパネルを表現するのに必要なbit数
    static final int W = 3; //基盤の幅
    static final int N = 3*3; //パネルの枚数

    HashMap<BitSet,State> hash; //確定したノードを記録しておくメモ
    PriorityQueue<State> queue; //未確定のノードを格納するキュー
    int[][] dirs = {{1,0}, {0,-1}, {-1,0}, {0,1}}; //右,上,左,下

    State solve(int[] board){
        hash = new HashMap<BitSet,State>();
        queue = new PriorityQueue<State>();
        BitSet bs = board2bs(board); //ボードの状態をBItSetで表現
        State state = new State(bs,0,-1); //初期状態のノード（盤面,手数,操作）
        queue.add(state); //初期状態のノードをキューに格納

        while(queue.size() > 0){ //キューにノードが存在する限り繰り返す
            State s = queue.poll(); //最も評価値が小さいノードを取り出して
        
            if(s.h1() == 0) {
                return s; //正しく並んだら終了
            }
            if(hash.get(s.bs) != null){
                continue; //メモに記録されたノードは調べない
            }
            hash.put(s.bs,s); //最短距離が確定したノードをメモする

            int zidx = getIndex(s.bs,0); //穴の位置を取り出し
            for(int i=0; i<dirs.length; i++){ //穴の上下左右のパネルを動かす
                int x = zidx % W; //穴の位置(x,y)
                int y = zidx / W;

                int nx = x + dirs[i][0]; //動かすパネルの位置(nx,ny)
                int ny = y + dirs[i][1];

                if(nx>=0 && nx<W && ny>=0 && ny<W){ //はみでていなければ
                    int tidx = nx + ny * W; //動かすパネルの一次元での位置
                    BitSet nbs = (BitSet) s.bs.clone(); //盤の状態をコピーして
                    int val = get(nbs,tidx); //動かすパネルに書いてある数字
                    int zero = get(nbs,zidx); //穴の数字（0のはず）
                    assert zero == 0; //確認
                    set(nbs,zidx,val); //穴の位置にパネルを動かし
                    set(nbs,tidx,zero); //元のパネルの位置に穴がくる

                    if(hash.get(nbs) != null){
                        continue; //メモにあれば捨てる
                    }
                    State ns = new State(nbs,s.distance+1,i); //手数と操作と組にして
                    queue.add(ns); //キューに入れる
                }
            }
        }
        return null;
    }

    BitSet prev(BitSet bs, int op){ //盤面と操作から一手前の盤面を求める
        BitSet pbs = (BitSet) bs.clone();
        int zidx = getIndex(pbs,0);
        int x = zidx % W;
        int y = zidx / W;
        int px = x - dirs[op][0];
        int py = y - dirs[op][1];
        assert px>=0 && px<W && py>=0 && py<W;

        int pidx = px + py * W;
        int val = get(pbs,pidx);
        int zero = get(pbs,zidx);
        assert zero == 0;
        set(pbs,zidx,val);
        set(pbs,pidx,zero);
        return pbs;
    }

    ArrayList<State> getPath(State s){ //その盤面に到るまでの盤面をArrayListで返す
        ArrayList<State> v = new ArrayList<State>();
        v.add(s);
        while(s.op >= 0){
            BitSet bs = prev(s.bs,s.op);
            s = hash.get(bs);
            assert s != null;
            v.add(s);
        }
        return v;
    }

    static BitSet board2bs(int[] board){ //盤面を表す配列からBitSetへ
        BitSet bs = new BitSet(BW*N);
        for(int i= 0; i<N; i++){
            set(bs,i,board[i]);
        }
        return bs;
    }

    static int[] bs2board(BitSet bs){ //盤面を表すBitSetから配列へ
        int[] b = new int[N];
        for(int i=0; i<N; i++){
            b[i] = get(bs, i);
        }
        return b;
    }

    static void set(BitSet bs,int idx,int val){ //idx番目のパネルの値をvalにする
        for(int i=0; i<BW; i++){
            bs.set(idx*BW+i,(val & 0x1)==1);
            val >>>=1;
        }
    }

    static int get(BitSet bs,int idx){ //idx番目のパネルの値を取り出す
        int val=0;
        for(int i=BW-1; i>=0; i--){
            val = val*2+((bs.get(idx*BW+i))? 1 : 0);
        }
        return val;
    }

    static int getIndex(BitSet bs,int val){ //値がvalのパネルの何番目か
        for(int i=0; i<N; i++){
            if(val == get(bs, i)){
                return i;
            }
        }
        return -1;
    }

    public static void main(String[] args){
        mode =0;
        if(args.length > 0){
            if(args[0].equals("-c")){
                mode = 1;
            }else if(args[0].equals("-d")){
                mode = 2;
            }
        }

        Scanner sc = new Scanner(System.in);
        int[] board = new int[N];
        for(int i=0; i<N; i++){
            board[i] = sc.nextInt();
        }
        sc.close();
        long start_time = System.currentTimeMillis();

        Puzzle p = new Puzzle();
        State s = p.solve(board);
        if(s == null){
            System.out.println("no answer");
            System.exit(-1);
        }
        ArrayList<State> v = p.getPath(s);
        System.out.println("path.size() =" + v.size());
        System.out.println("hash.size() =" + p.hash.size());
        
        long end_time = System.currentTimeMillis();
        System.out.println("実行時間："+(end_time-start_time)+"ms");
    }

    static class State implements Comparable<State>{ //ノード（盤面,手数,操作）
        BitSet bs;
        int distance;
        int op;
        int f;

        public State(BitSet bs,int distance,int op){
            this.bs = bs;
            this.op = op;
            this.distance = distance;
            f = distance + ((mode==2)?h2():((mode==1)?h1():0));           
        }

        public int compareTo(State s){ //比較に使う
            return f-s.f;
        }

        int h1()
            {
            int unmatched =0;
            int[] board = bs2board(this.bs);
            for(int i=0;i<N-1;i++){
                if(board[i]!=i+1){
                    unmatched++;
                }
            }
            return unmatched;
        }

        int h2(){
            int manhattan = 0;
            int[] board = bs2board(this.bs);
            for(int i=0;i<N-1;i++){
                int dx = Math.abs((board[i]-1)%W-(i)%W); 
                int dy = Math.abs((board[i]-1)/W-(i)/W);
                manhattan = manhattan + dx +dy;
            }
            return manhattan;
        }


        public String toString(){
            StringBuffer sb = new StringBuffer();
            for(int i=0; i<N; i++){
                sb.append(Puzzle.get(bs,i) + (((i+1)%W==0)?"\n":" "));
            }
            return sb.toString();
        }
    }

}
