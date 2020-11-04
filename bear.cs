using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;
using UnityEditor.Animations;

using UnityEngine.Video;

public class bear : MonoBehaviour
{
    public Canvas canvas;
    public Font font;
    private Animation anima;
    private AnimationClip clip;
    private Animator animator;
    private GameObject img1;
    private Sprite image1;
    private GameObject img2;
    private Image image2;
    private GameObject img3;
    private Image image3;
    private GameObject img4;
    private Image image4;

    private GameObject cam1;
    private VideoPlayer player1;
    
    private GameObject cam3;
    private VideoPlayer player3;

    private GameObject cam4;
    private VideoPlayer player4;

    private GameObject buttonEat;
    private GameObject buttonSleep;
    private GameObject buttonReturn;
    


    void Show(GameObject cam)
    {
        cam.GetComponent<Camera>().depth = 0;
    }

    void Hide(GameObject cam)
    {
        cam.GetComponent<Camera>().depth = -1;
    }

    void Start()
    {
        cam1 = GameObject.Find("cam1");
        cam3 = GameObject.Find("cam3");
        cam4 = GameObject.Find("cam4");

        // GameObject root = GameObject.Find("SampleScene");
        //root.AddComponent<GameObject>(cam1);

        Show(cam1);
        Hide(cam3);
        Hide(cam4);

        //https://docs.unity3d.com/ScriptReference/Video.VideoPlayer.html
        player1 = cam1.AddComponent<VideoPlayer>();
        player1.audioOutputMode = VideoAudioOutputMode.None;
        player1.playOnAwake = false;
        //player1.url = "file://C:/Programming/C#/Bear/Data/one.mp4";
        VideoClip clip1 = Resources.Load<VideoClip>("one") as VideoClip;
        player1.clip = clip1;
        player1.isLooping = true;
        player1.Prepare();

        player3 = cam3.AddComponent<VideoPlayer>();
        player3.audioOutputMode = VideoAudioOutputMode.None;
        player3.playOnAwake = false;
        VideoClip clip3 = Resources.Load<VideoClip>("three") as VideoClip;
        player3.clip = clip3;
        player3.loopPointReached += VideoEndReached;
        player3.Prepare();

        player4 = cam4.AddComponent<VideoPlayer>();
        player4.audioOutputMode = VideoAudioOutputMode.None;
        player4.playOnAwake = false;
        VideoClip clip4 = Resources.Load<VideoClip>("four") as VideoClip;
        player4.clip = clip4;
        player4.loopPointReached += VideoEndReached;
        player4.Prepare();

        
        

        player1.Play();
        buttonEat = DrawButton("buttonEat", 10, 90, 10, 5, delegate { OnButton(cam3); });
        buttonSleep = DrawButton("buttonSleep", 90, 90, 10, 5, delegate { OnButton(cam4); });
        buttonReturn = DrawButton("buttonReturn", 10, 10, 10, 5, delegate { VideoEndReached(player3); VideoEndReached(player4); });
        buttonReturn.SetActive(false);
    }

    GameObject DrawButton(string name, int x, int y, int width = 8, int height = 8, UnityEngine.Events.UnityAction act = null)
    {
        GameObject button = new GameObject(name, typeof(Button), typeof(Image), typeof(Animation), typeof(LayoutElement), typeof(Animator));

        //var vp = camera.AddComponent<UnityEngine.Video.VideoPlayer>();
        button.transform.SetParent(canvas.transform);
        button.GetComponent<RectTransform>().sizeDelta = new Vector2((width * Screen.width) / 100, (height * Screen.height) / 100);
      
        Vector3 pos = button.transform.position;
        pos.x = (x * Screen.width) / 100;
        pos.y = ((100 - y) * Screen.height) / 100;
        button.transform.position = pos;

        AnimatorController cntrl = Resources.Load<AnimatorController>("buttonEat");
        button.GetComponent<Animator>().runtimeAnimatorController = cntrl;


       

        //Image img = button.GetComponent<Image>();
        //img = Resources.Load<Image>("MuoseUp");
        //var comps = button.gameObject.GetComponentInChildren<Text>();
        //comps.text = "ASDF";
        //clip = Resources.Load<an>("animation");
        //animator = button.GetComponent<Animator>();
        //anima.AddClip(clip, "animation");
       //foreach (AnimationState state in anima)
        //{
       //     state.speed = 0.5F;
       // }
        

        // GameObject txt = new GameObject("txt", typeof(Text));
        //Text label = txt.GetComponent<Text>();
        // label.transform.SetParent(button.transform);
        // label.GetComponent<RectTransform>().sizeDelta = new Vector2((width * Screen.width) / 100, (height * Screen.height) / 100);
        // label.text = name;
        // label.font = Resources.Load<Font>("calibri");
        //  label.color = new Color (0,0,0);

        if (act != null)
        {
            // AnimatorController(x, y, width, height);
            //   anima.Play();
            
            button.GetComponent<Button>().onClick.AddListener(act);
        }
       
        return button;
    }
    
    void OnButton(GameObject cam)
    {
        buttonEat.SetActive(false);
        buttonSleep.SetActive(false);
        
        

        cam.GetComponent<VideoPlayer>().Play();
        Show(cam);
        Hide(cam1);
        player1.Pause();
        buttonReturn.SetActive(true);
    }

    void VideoEndReached(UnityEngine.Video.VideoPlayer vp)
    {
        buttonReturn.SetActive(false);

        Show(cam1);
        Hide(cam3);
        Hide(cam4);
        player1.Play();
        vp.Prepare();

        buttonEat.SetActive(true);
        buttonSleep.SetActive(true);
    }

    void Update()
    {

    }

}
