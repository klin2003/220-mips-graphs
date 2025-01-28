import java.util.Arrays;
import org.junit.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;

import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw4Test {

    private int reg_sp = 0;
    private int reg_s0 = 0;
    private int reg_s1 = 0;
    private int reg_s2 = 0;
    private int reg_s3 = 0;
    private int reg_s4 = 0;
    private int reg_s5 = 0;
    private int reg_s6 = 0;
    private int reg_s7 = 0;

    @Rule
    public Timeout timeout = new Timeout(20000, TimeUnit.MILLISECONDS);

    @Before
    public void preTest() {
        this.reg_s0 = get(s0);
        this.reg_s1 = get(s1);
        this.reg_s2 = get(s2);
        this.reg_s3 = get(s3);
        this.reg_s4 = get(s4);
        this.reg_s5 = get(s5);
        this.reg_s6 = get(s6);
        this.reg_s7 = get(s7);
        this.reg_sp = get(sp);
    }

    @After
    public void postTest() {
        Assert.assertEquals("Register convention violated $s0", this.reg_s0, get(s0));
        Assert.assertEquals("Register convention violated $s1", this.reg_s1, get(s1));
        Assert.assertEquals("Register convention violated $s2", this.reg_s2, get(s2));
        Assert.assertEquals("Register convention violated $s3", this.reg_s3, get(s3));
        Assert.assertEquals("Register convention violated $s4", this.reg_s4, get(s4));
        Assert.assertEquals("Register convention violated $s5", this.reg_s5, get(s5));
        Assert.assertEquals("Register convention violated $s6", this.reg_s6, get(s6));
        Assert.assertEquals("Register convention violated $s7", this.reg_s7, get(s7));
        Assert.assertEquals("Register convention violated $sp", this.reg_sp, get(sp));
    }
/*
    @Test
    public void create_net1(){
        run("create_network", -5, 10);
        Assert.assertEquals(-1, get(v0));
    }

    @Test
    public void create_net2(){
        run("create_network", 5, -10);
        Assert.assertEquals(-1, get(v0));
    }

    @Test
    public void create_net3(){
        run("create_network", -5, -10);
        Assert.assertEquals(-1, get(v0));
    }

    @Test
    public void create_net4(){
        run("create_network", 0, 0);
        Assert.assertNotEquals(-1, get(v0));
        Assert.assertEquals(0, getWord(get(v0)));
        Assert.assertEquals(0, getWord(get(v0) + 4));
    }

    @Test
    public void create_net5(){
        int i = (int)(Math.random() * 8) + 2;
        int j = (int)(Math.random() * 8) + 2;
        run("create_network", i, j);
        Assert.assertNotEquals(-1, get(v0));
        Assert.assertEquals(i, getWord(get(v0)));
        Assert.assertEquals(j, getWord(get(v0) + 4));
    }

    @Test
    public void add_person1(){
        run("create_network", 5, 10);
        int i = get(v0);
        Assert.assertEquals(5, getWord(get(v0)));
        Assert.assertEquals(10, getWord(get(v0) + 4));

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "");
        run("add_person", inp_network, msg);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }
    


    @Test
    public void add_person2(){
        run("create_network", 0, 10);
        int i = get(v0);
        Assert.assertEquals(0, getWord(get(v0)));
        Assert.assertEquals(10, getWord(get(v0) + 4));

        Label inp_network = wordData(getWords(i, 14));
        Label msg = asciiData(true, "Jane");

        run("add_person", inp_network, msg);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }


    @Test
    public void add_person3(){
        run("create_network", 5, 10);
        int i = get(v0);
        Assert.assertEquals(5, getWord(get(v0)));
        Assert.assertEquals(10, getWord(get(v0) + 4));
        Assert.assertEquals(0, getWord(get(v0) + 8));
        Assert.assertEquals(0, getWord(get(v0) + 12));

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jane");
        run("add_person", inp_network, msg);
        Assert.assertEquals(inp_network.address(), get(v0));
        Assert.assertEquals(1, getWord(get(v0) + 8));
        Assert.assertEquals(1, get(v1));
        Assert.assertEquals("Jane", getString(getWord(get(v0) + 16) + 4));
    }
*/
    @Test
    public void add_person4(){
        run("create_network", 5, 10);
        int i = get(v0);
        Assert.assertEquals(5, getWord(get(v0)));
        Assert.assertEquals(10, getWord(get(v0) + 4));
        Assert.assertEquals(0, getWord(get(v0) + 8));
        Assert.assertEquals(0, getWord(get(v0) + 12));

        Arrays.stream(getWords(268697600, 120)).forEach(s -> System.out.println(s));
        Label inp_network = wordData(getWords(268500992, 49272));
        Label msg = asciiData(true, "Jerry");

        run("add_person", i, msg);
        Assert.assertEquals(i, get(v0));
        Assert.assertEquals(1, get(v1));

        msg = asciiData(true, "Jerry");
        inp_network = wordData(getWords(268500992, 49272));
        run("add_person", i, msg);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));

    }
/*
    @Test
    public void add_person5(){
        run("create_network", 5, 10);
        int i = get(v0);
        Assert.assertEquals(5, getWord(get(v0)));
        Assert.assertEquals(10, getWord(get(v0) + 4));
        Assert.assertEquals(0, getWord(get(v0) + 8));
        Assert.assertEquals(0, getWord(get(v0) + 12));

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");

        run("add_person", inp_network, msg);
        Assert.assertEquals(inp_network.address(), get(v0));
        Assert.assertEquals(1, get(v1));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Francis");
        run("add_person", inp_network, msg);
        Assert.assertEquals(inp_network.address(), get(v0));
        Assert.assertEquals(1, get(v1));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Linus");
        run("add_person", inp_network, msg);
        Assert.assertEquals(inp_network.address(), get(v0));
        Assert.assertEquals(1, get(v1));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Demetrius");
        run("add_person", inp_network, msg);
        Assert.assertEquals(inp_network.address(), get(v0));
        Assert.assertEquals(1, get(v1));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Daniel");
        run("add_person", inp_network, msg);
        Assert.assertEquals(inp_network.address(), get(v0));
        Assert.assertEquals(1, get(v1));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Prince");
        run("add_person", inp_network, msg);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void get_person1(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Jane");
        run("get_person", inp_network, msg);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void get_person2(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Jerry");
        run("get_person", inp_network, msg);
        Assert.assertEquals(5, getWord(get(v0)));
        Assert.assertEquals("Jerry", getString(get(v0) + 4));
    }


    @Test
    public void get_person3(){
        run("create_network", 5, 10);
        int i = get(v0);
        Assert.assertEquals(5, getWord(get(v0)));
        Assert.assertEquals(10, getWord(get(v0) + 4));
        Assert.assertEquals(0, getWord(get(v0) + 8));
        Assert.assertEquals(0, getWord(get(v0) + 12));

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(i, 19));
        msg = asciiData(true, "Jerry");
        run("get_person", inp_network, msg);
        Assert.assertEquals("Jerry", getString(get(v0)));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Francis");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(i, 19));
        msg = asciiData(true, "Francis");
        run("get_person", inp_network, msg);
        Assert.assertEquals("Francis", getString(get(v0)));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Linus");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(i, 19));
        msg = asciiData(true, "Linus");
        run("get_person", inp_network, msg);
        Assert.assertEquals("Linus", getString(get(v0)));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Demetrius");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(i, 19));
        msg = asciiData(true, "Demetrius");
        run("get_person", inp_network, msg);
        Assert.assertEquals("Demetrius", getString(get(v0)));

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Daniel");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(i, 19));
        msg = asciiData(true, "Daniel");
        run("get_person", inp_network, msg);
        Assert.assertEquals("Daniel", getString(get(v0)));
    }

    @Test
    public void add_relation1(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Demetrius");
        run("add_person", inp_network, msg);

        Label msg1 = asciiData(true, "Jerry");
        Label msg2 = asciiData(true, "Demetrius");
        inp_network = wordData(getWords(inp_network.address(), 19));
        run("add_relation", inp_network, msg1, msg2, -1);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void add_relation2(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Demetrius");
        run("add_person", inp_network, msg);

        Label msg1 = asciiData(true, "Jerry");
        Label msg2 = asciiData(true, "Demetrius");
        inp_network = wordData(getWords(inp_network.address(), 19));
        run("add_relation", inp_network, msg1, msg2, 4);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void add_relation3(){
        run("create_network", 5, 0);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Demetrius");
        run("add_person", inp_network, msg);

        Label msg1 = asciiData(true, "Jerry");
        Label msg2 = asciiData(true, "Demetrius");
        inp_network = wordData(getWords(inp_network.address(), 19));
        run("add_relation", inp_network, msg1, msg2, 1);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void add_relation4(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        Label msg1 = asciiData(true, "Jane");
        Label msg2 = asciiData(true, "Jerry");
        inp_network = wordData(getWords(inp_network.address(), 19));
        run("add_relation", inp_network, msg1, msg2, 1);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void add_relation5(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        Label msg1 = asciiData(true, "Jerry");
        Label msg2 = asciiData(true, "Jane");
        inp_network = wordData(getWords(inp_network.address(), 19));
        run("add_relation", inp_network, msg1, msg2, 1);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void add_relation6(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        Label msg1 = asciiData(true, "Jerry");
        Label msg2 = asciiData(true, "Jerry");
        inp_network = wordData(getWords(inp_network.address(), 19));
        run("add_relation", inp_network, msg1, msg2, 1);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void add_relation7(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        Label msg1 = asciiData(true, "Jerry");
        Label msg2 = asciiData(true, "Jerry");
        inp_network = wordData(getWords(inp_network.address(), 19));
        run("add_relation", inp_network, msg1, msg2, 1);
        Assert.assertEquals(-1, get(v0));
        Assert.assertEquals(-1, get(v1));
    }

    @Test
    public void add_relation8(){
        run("create_network", 5, 10);
        int i = get(v0);

        Label inp_network = wordData(getWords(i, 19));
        Label msg = asciiData(true, "Jerry");
        run("add_person", inp_network, msg);

        inp_network = wordData(getWords(inp_network.address(), 19));
        msg = asciiData(true, "Demetrius");
        run("add_person", inp_network, msg);

        Label msg1 = asciiData(true, "Jerry");
        Label msg2 = asciiData(true, "Demetrius");
        inp_network = wordData(getWords(inp_network.address(), 19));
        run("add_relation", inp_network, msg1, msg2, 1);
        Assert.assertEquals(1, get(v1));
    }

*/
}
